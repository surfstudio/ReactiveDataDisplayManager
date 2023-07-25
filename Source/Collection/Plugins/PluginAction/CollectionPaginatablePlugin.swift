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

    private var isLoading = false
    private var isErrorWasReceived = false
    private var direction: PagingDirection

    // MARK: - Properties

    weak var collectionView: UICollectionView?
    var paginationStrategy: PaginationStrategy?

    /// Property which indicating availability of pages
    public private(set) var canIterate = false {
        didSet {
            if canIterate {
                guard progressView.superview == nil else {
                    return
                }
                paginationStrategy?.addPafinationView()
            } else {
                guard progressView.superview != nil else {
                    return
                }
                paginationStrategy?.removePafinationView()
            }
        }
    }

    // MARK: - Initialization

    /// - parameter progressView: indicator view to add inside footer. Do not forget to init this view with valid frame size.
    /// - parameter output: output signals to hide  `progressView` from footer
    init(progressView: ProgressView, with output: PaginatableOutput, direction: PagingDirection = .forward(.bottom)) {
        self.progressView = progressView
        self.output = output
        self.direction = direction
    }

    // MARK: - BaseTablePlugin

    public override func setup(with manager: BaseCollectionManager?) {
        collectionView = manager?.view
        paginationStrategy?.scrollView = manager?.view
        paginationStrategy?.progressView = progressView
        canIterate = false
        output?.onPaginationInitialized(with: self, at: direction)
        self.progressView.setOnRetry { [weak self] in
            guard let input = self, let output = self?.output, let direction = self?.direction else {
                return
            }
            self?.isErrorWasReceived = false
            output.loadNextPage(with: input, at: direction)
        }
    }

    public override func process(event: CollectionEvent, with manager: BaseCollectionManager?) {

        switch event {
        case .willDisplayCell(let indexPath):
            if progressView.frame.minY != collectionView?.contentSize.height {
                paginationStrategy?.setProgressViewFinalFrame()
            }
            guard indexPath == paginationStrategy?.getIndexPath(with: manager), canIterate, !isLoading, !isErrorWasReceived else {
                return
            }
            output?.loadNextPage(with: self, at: self.direction)
        default:
            break
        }
    }

}

// MARK: - PaginatableInput

extension CollectionPaginatablePlugin: PaginatableInput {

    public func updatePaginationEnabled(_ canIterate: Bool, at direction: PagingDirection) {
        self.canIterate = canIterate
        self.direction = direction

        paginationStrategy?.resetOffset(canIterate: canIterate)
    }

    public func updatePaginationState(_ state: PaginationState, at direction: PagingDirection) {
        switch state {
        case .idle:
            isLoading = false
        case .loading:
            isLoading = true
            paginationStrategy?.saveCurrentState()
        case .error(let error):
            isLoading = false
            isErrorWasReceived = true
            progressView.showError(error)
        }
        progressView.showProgress(isLoading)
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
    static func topPaginatable(progressView: CollectionPaginatablePlugin.ProgressView,
                               output: PaginatableOutput) -> CollectionPaginatablePlugin {
        let plugin = CollectionPaginatablePlugin(progressView: progressView, with: output, direction: .backward(.top))
        plugin.paginationStrategy = TopPaginationStrategy()
        return plugin
    }

    /// Plugin to display `progressView` while next page is loading
    ///
    /// Show `progressView` on `willDisplay` last cell.
    /// Hide `progressView` when finish loading request
    ///
    /// - parameter progressView: indicator view to add inside footer. Do not forget to init this view with valid frame size.
    /// - parameter output: output signals to hide  `progressView` from footer
    static func bottomPaginatable(progressView: CollectionPaginatablePlugin.ProgressView,
                                  output: PaginatableOutput) -> CollectionPaginatablePlugin {
        let plugin = CollectionPaginatablePlugin(progressView: progressView, with: output, direction: .forward(.bottom))
        plugin.paginationStrategy = BottomPaginationStrategy()
        return plugin
    }

}
