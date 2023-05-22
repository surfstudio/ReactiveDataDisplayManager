//
//  CollectionPaginatablePlugin.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 16.03.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

/// Plugin to display `progressView` while next page is loading
///
/// - Show `progressView` on `willDisplay` last cell.
/// - Hide `progressView` when finish loading request
///
/// - Warning: Specify itemSize of your layout to proper `willDisplay` calls and correct `contentSize`
public class CollectionPaginatablePlugin: BaseCollectionPlugin<CollectionEvent> {

    // MARK: - Typealias

    public typealias ProgressView = UIView & ProgressDisplayableItem

    // MARK: - Private Properties

    private let progressView: ProgressView
    private weak var output: PaginatableOutput?

    private var isLoading: Bool = false

    private weak var collectionView: UICollectionView?

    /// Property which indicating availability of pages
    public private(set) var canIterate = false {
        didSet {
            if canIterate {
                guard progressView.superview == nil else {
                    return
                }

                collectionView?.addSubview(progressView)
                collectionView?.contentInset.bottom += progressView.frame.height
            } else {
                guard progressView.superview != nil else {
                    return
                }

                progressView.removeFromSuperview()
                collectionView?.contentInset.bottom -= progressView.frame.height
            }
        }
    }

    // MARK: - Initialization

    /// - parameter progressView: indicator view to add inside footer. Do not forget to init this view with valid frame size.
    /// - parameter output: output signals to hide  `progressView` from footer
    init(progressView: ProgressView, with output: PaginatableOutput) {
        self.progressView = progressView
        self.output = output
    }

    // MARK: - BaseTablePlugin

    public override func setup(with manager: BaseCollectionManager?) {
        collectionView = manager?.view
        canIterate = false
        output?.onPaginationInitialized(with: self)
        self.progressView.setOnRetry { [weak self] in
            guard let input = self, let output = self?.output else {
                return
            }
            output.loadNextPage(with: input)
        }
    }

    public override func process(event: CollectionEvent, with manager: BaseCollectionManager?) {

        switch event {
        case .willDisplayCell(let indexPath, _):
            guard let generators = manager?.generators else {
                return
            }
            let lastSectionIndex = generators.count - 1
            let lastCellInLastSectionIndex = generators[lastSectionIndex].count - 1

            let lastCellIndexPath = IndexPath(row: lastCellInLastSectionIndex, section: lastSectionIndex)
            guard indexPath == lastCellIndexPath, canIterate, !isLoading else {
                return
            }

            // Hack: Update progressView position. Imitation of global footer view like `tableFooterView`
            progressView.frame = .init(origin: .init(x: progressView.frame.origin.x,
                                                     y: collectionView?.contentSize.height ?? 0),
                                       size: progressView.frame.size)

            output?.loadNextPage(with: self)
        default:
            break
        }
    }

}

// MARK: - PaginatableInput

extension CollectionPaginatablePlugin: PaginatableInput {

    public func updateProgress(isLoading: Bool) {
        self.isLoading = isLoading
        progressView.showProgress(isLoading)
    }

    public func updateError(_ error: Error?) {
        progressView.showError(error)
    }

    public func updatePagination(canIterate: Bool) {
        self.canIterate = canIterate
    }

}

// MARK: - Public init

public extension BaseCollectionPlugin {

    /// Plugin to display `progressView` while next page is loading
    ///
    /// Show `progressView` on `willDisplay` last cell.
    /// Hide `progressView` when finish loading request
    ///
    /// - parameter progressView: indicator view to add inside footer. Do not forget to init this view with valid frame size.
    /// - parameter output: output signals to hide  `progressView` from footer
    static func paginatable(progressView: CollectionPaginatablePlugin.ProgressView,
                            output: PaginatableOutput) -> CollectionPaginatablePlugin {
        .init(progressView: progressView, with: output)
    }

}
