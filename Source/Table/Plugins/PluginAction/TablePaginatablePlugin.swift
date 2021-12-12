//
//  TablePaginatablePlugin.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 03.03.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

public protocol ProgressDisplayableItem {

    /// - parameter isLoading: `true` if want to animate loading progress in `progressView`
    func showProgress(_ isLoading: Bool)

}

/// Input signals to control visibility of progressView in footer
public protocol PaginatableInput: AnyObject {

    /// Call this method to control availability of **loadNextPage** action
    ///
    /// - parameter canIterate: `true` if want to use last cell will display event to execute **loadNextPage** action
    func updatePagination(canIterate: Bool)

    /// Call this method to control visibility of progressView in footer
    ///
    /// - parameter isLoading: `true` if want to show `progressView` in footer
    func updateProgress(isLoading: Bool)
}

/// Output signals for loading next page of content
public protocol PaginatableOutput: AnyObject {

    /// Called when collection has setup `TablePaginatablePlugin`
    ///
    /// - parameter input: input signals to hide  `progressView` from footer
    func onPaginationInitialized(with input: PaginatableInput)

    /// Called when collection scrolled to last cell
    ///
    /// - parameter input: input signals to hide  `progressView` from footer
    func loadNextPage(with input: PaginatableInput)
}

/// Plugin to display `progressView` while next page is loading
///
/// Show `progressView` on `willDisplay` last cell.
/// Hide `progressView` when finish loading request
///
/// - Warning: Specify estimatedRowHeight of your layout to proper `willDisplay` calls and correct `contentSize`
public class TablePaginatablePlugin: BaseTablePlugin<TableEvent> {

    public typealias ProgressView = UIView & ProgressDisplayableItem

    // MARK: - Private Properties

    private let progressView: ProgressView
    private weak var output: PaginatableOutput?

    private weak var tableView: UITableView?

    /// Property which indicating availability of pages
    public private(set) var canIterate = false {
        didSet {
            if canIterate {
                tableView?.tableFooterView = progressView
            } else {
                tableView?.tableFooterView = nil
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

    public override func setup(with manager: BaseTableManager?) {
        self.tableView = manager?.view
        self.canIterate = false
        self.output?.onPaginationInitialized(with: self)
    }

    public override func process(event: TableEvent, with manager: BaseTableManager?) {

        switch event {
        case .willDisplayCell(let indexPath):
            guard let sections = manager?.sections else {
                return
            }
            let lastSectionIndex = sections.count - 1
            let lastCellInLastSectionIndex = sections[lastSectionIndex].generators.count - 1

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

extension TablePaginatablePlugin: PaginatableInput {

    public func updateProgress(isLoading: Bool) {
        progressView.showProgress(isLoading)
    }

    public func updatePagination(canIterate: Bool) {
        self.canIterate = canIterate
    }

}

// MARK: - Public init

public extension BaseTablePlugin {

    /// Plugin to display `progressView` while next page is loading
    ///
    /// Show `progressView` on `willDisplay` last cell.
    /// Hide `progressView` when finish loading request
    ///
    /// - parameter progressView: indicator view to add inside footer. Do not forget to init this view with valid frame size.
    /// - parameter output: output signals to hide  `progressView` from footer
    static func paginatable(progressView: TablePaginatablePlugin.ProgressView,
                            output: PaginatableOutput) -> TablePaginatablePlugin {
        .init(progressView: progressView, with: output)
    }

}
