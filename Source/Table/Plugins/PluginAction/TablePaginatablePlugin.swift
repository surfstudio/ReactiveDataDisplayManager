//
//  TablePaginatablePlugin.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 03.03.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

public enum PaginationDirection {

    case backward
    case forward

}

public protocol ProgressDisplayableItem {

    /// - parameter isLoading: `true` if want to animate loading progress in `progressView`
    func showProgress(_ isLoading: Bool)

    /// - parameter error: some error got while loading of next/previous page.
    ///  You should transfer this error into UI representation.
    /// - Warning: - default implementation is empty.
    func showError(_ error: Error?)

    /// - parameter action: bind to `PaginatableOutput.loadNextPage` / `PaginatableOutput.loadPrevPage` inside plugin
    ///  - Implement this method if you have retry button on your error-state view.
    /// - Warning: - default implementation is empty.
    func setOnRetry(action: @escaping () -> Void)

}

// MARK: - Default ProgressDisplayableItem

extension ProgressDisplayableItem {

    func showError(_ error: Error?) { }

    func setOnRetry(action: @escaping () -> Void) { }

}

/// Input signals to control visibility of progressView in footer
public protocol PaginatableInput: AnyObject {

    /// Call this method to control availability of **loadNextPage** action
    ///
    /// - parameter canIterate: `true` if want to use last cell will display event to execute **loadNextPage** action
    func updatePagination(canIterate: Bool)

    /// Call this method to control visibility of progressView in header/footer
    ///
    /// - parameter isLoading: `true` if want to show `progressView` in header/footer
    func updateProgress(isLoading: Bool)

    /// - parameter error: some error got while loading of next/previous page.
    ///  You should transfer this error into UI representation.
    func updateError(_ error: Error?)
}

/// Input signals to control visibility of progressView in header
public protocol BackwardPaginatableInput: AnyObject {

    /// Call this method to control availability of **loadPrevPage** action
    ///
    /// - parameter canIterate: `true` if want to use first cell will display event to execute **loadPrevPage**action
    func updatePagination(canIterate: Bool)

    /// Call this method to return to initial scroll position before loading. Must be called just **after** finish updateProgress(isLoading: true) and updatePagination actions
    func returnToScrollPositionBeforeLoading()

    /// Call this method to control visibility of progressView in footer
    ///
    /// - parameter isLoading: `true` if want to show `progressView` in footer
    func updateProgress(isLoading: Bool)

    /// - parameter error: some error got while loading of previous page.
    ///  You should transfer this error into UI representation.
    func updateError(_ error: Error?)
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

/// Output signals for loading previous page of content
public protocol BackwardPaginatableOutput: AnyObject {

    /// Called when collection has setup `TableBackwardPaginatablePlugin`
    ///
    /// - parameter input: input signals to hide  `progressView` from header
    func onBackwardPaginationInitialized(with input: BackwardPaginatableInput)

    /// Called when collection scrolled to first cell
    ///
    /// - parameter input: input signals to hide  `progressView` from header
    func loadPrevPage(with input: BackwardPaginatableInput)
}

/// Plugin to display `progressView` while next/previous page is loading
///
/// Show `progressView` on `willDisplay` first/last cell.
/// Hide `progressView` when finish loading request
///
/// - Warning: Specify estimatedRowHeight of your layout to proper `willDisplay` calls and correct `contentSize`
public class TablePaginatablePlugin: BaseTablePlugin<TableEvent> {

    // MARK: - Nested types

    public typealias ProgressView = UIView & ProgressDisplayableItem

    // MARK: - Private Properties

    private let progressView: ProgressView
    private weak var output: PaginatableOutput?

    private var isLoading = false

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
        self.progressView.setOnRetry { [weak self] in
            guard let input = self, let output = self?.output else {
                return
            }
            output.loadNextPage(with: input)
        }
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
            if indexPath == lastCellIndexPath && canIterate && !isLoading {
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
        return TablePaginatablePlugin(progressView: progressView, with: output)

    }

    /// Plugin to display `progressView` while previous page is loading
    ///
    /// Show `progressView` on `willDisplay` first cell.
    /// Hide `progressView` when finish loading request
    ///
    /// - parameter progressView: indicator view to add inside header. Do not forget to init this view with valid frame size.
    /// - parameter output: output signals to hide  `progressView` from header
    static func backwardPaginatable(progressView: TableBackwardPaginatablePlugin.ProgressView,
                                    output: BackwardPaginatableOutput) -> TableBackwardPaginatablePlugin {
        return TableBackwardPaginatablePlugin(progressView: progressView, with: output)

    }

}
