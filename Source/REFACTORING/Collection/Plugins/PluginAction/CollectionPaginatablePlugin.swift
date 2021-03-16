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
/// Show `progressView` on `willDisplay` last cell.
/// Hide `progressView` when finish loading request
public class CollectionPaginatablePlugin: BaseCollectionPlugin<CollectionEvent>  {

    public typealias ProgressView = UIView & ProgressDisplayableItem

    // MARK: - Private Properties

    private let progressView: ProgressView
    private weak var output: PaginatableOutput?

    private weak var collectionView: UICollectionView?

    /// Property which indicating availability of pages
    public private(set) var canIterate = false {
        didSet {
            // TODO: - придумать способ вставки вью в глобальный футер
//            if canIterate {
//                collectionView?.tableFooterView = progressView
//            } else {
//                collectionView?.tableFooterView = nil
//            }
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
        self.collectionView = manager?.view
        self.canIterate = false
        self.output?.onPaginationInitialized(with: self)
    }

    public override func process(event: CollectionEvent, with manager: BaseCollectionManager?) {

        switch event {
        case .willDisplayCell(let indexPath):
            guard let generators = manager?.generators else {
                return
            }
            let lastSectionIndex = generators.count - 1
            let lastCellInLastSectionIndex = generators[lastSectionIndex].count - 1

            let lastCellIndexPath = IndexPath(row: lastCellInLastSectionIndex, section: lastSectionIndex)
            if indexPath == lastCellIndexPath && canIterate {
                output?.loadNextPage(with: self)
            }
        default:
            break
        }
    }

}

// MARK: - PaginatableInput

extension CollectionPaginatablePlugin: PaginatableInput {

    public func updateProgress(isLoading: Bool) {
        progressView.showProgress(isLoading)
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
