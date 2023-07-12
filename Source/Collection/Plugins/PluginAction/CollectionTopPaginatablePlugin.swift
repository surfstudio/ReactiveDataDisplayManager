//
//  CollectionTopPaginatablePlugin.swift
//  ReactiveDataDisplayManager
//
//  Created by Антон Голубейков on 23.06.2023.
//

import UIKit

/// Plugin to display `progressView` while prevous page is loading
///
/// Show `progressView` on `willDisplay` first cell.
/// Hide `progressView` when finish loading request
///
/// - Warning: Specify itemSize of your layout to proper `willDisplay` calls and correct `contentSize`
public class CollectionTopPaginatablePlugin: BaseCollectionPlugin<CollectionEvent> {

    // MARK: - Nested types

    public typealias ProgressView = UIView & ProgressDisplayableItem

    // MARK: - Private Properties

    private let progressView: ProgressView
    private weak var output: TopPaginatableOutput?
    private let isSaveScrollPositionNeeded: Bool

    private var isLoading = false
    private var isErrorWasReceived = false

    private weak var collectionView: UICollectionView?

    private var currentContentHeight: CGFloat?

    /// Property which indicating availability of pages
    public private(set) var canIterate = false {
        didSet {
            if canIterate {
                guard progressView.superview == nil else {
                    return
                }

                collectionView?.addSubview(progressView)
                collectionView?.contentInset.top += progressView.frame.height
            } else {
                guard progressView.superview != nil else {
                    return
                }

                progressView.removeFromSuperview()
                collectionView?.contentInset.top -= progressView.frame.height
            }
        }
    }

    // MARK: - Initialization

    /// - parameter progressView: indicator view to add inside header. Do not forget to init this view with valid frame size.
    /// - parameter output: output signals to hide  `progressView` from header
    init(progressView: ProgressView, with output: TopPaginatableOutput, isSaveScrollPositionNeeded: Bool = true) {
        self.progressView = progressView
        self.output = output
        self.isSaveScrollPositionNeeded = isSaveScrollPositionNeeded
    }

    // MARK: - BaseTablePlugin

    public override func setup(with manager: BaseCollectionManager?) {
        collectionView = manager?.view
        canIterate = false
        output?.onTopPaginationInitialized(with: self)
        self.progressView.setOnRetry { [weak self] in
            guard let input = self, let output = self?.output else {
                return
            }
            self?.isErrorWasReceived = false
            output.loadPrevPage(with: input)
        }
    }

    public override func process(event: CollectionEvent, with manager: BaseCollectionManager?) {

        switch event {
        case .willDisplayCell(let indexPath):
            let firstCellIndexPath = IndexPath(row: 0, section: 0)
            guard indexPath == firstCellIndexPath, canIterate, !isLoading, !isErrorWasReceived else {
                return
            }

            // Hack: Update progressView position. Imitation of global header view like `tableHeaderView`

            progressView.frame = .init(origin: .init(x: progressView.frame.origin.x, y: -progressView.frame.height),
                                       size: progressView.frame.size)

            output?.loadPrevPage(with: self)
        default:
            break
        }
    }

}

// MARK: - PaginatableInput

extension CollectionTopPaginatablePlugin: TopPaginatableInput {

    public func updateProgress(isLoading: Bool) {
        self.isLoading = isLoading
        progressView.showProgress(isLoading)
        if isLoading {
            currentContentHeight = collectionView?.contentSize.height
        }
    }

    public func updateError(_ error: Error?) {
        progressView.showError(error)
        isErrorWasReceived = true
    }

    public func updatePagination(canIterate: Bool) {
        self.canIterate = canIterate
        if
            canIterate,
            let currentContentHeight = currentContentHeight,
            let newContentHeight = collectionView?.contentSize.height
        {
            let finalOffset = CGPoint(x: 0, y: newContentHeight - currentContentHeight - progressView.frame.height)
            collectionView?.setContentOffset(finalOffset, animated: false)
            self.currentContentHeight = nil
        }
    }

}
