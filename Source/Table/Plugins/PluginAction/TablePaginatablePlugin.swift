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
    /// - Parameters:
    ///  - canIterate: `true` if want to use last cell will display event to execute **loadNextPage** action
    ///  - direction: direction of pagination
    func updatePaginationEnabled(_ canIterate: Bool, at direction: PagingDirection)

    /// Call this method to control visibility of progressView in header/footer, loading/error state
    /// - Parameters:
    /// - state: state of pagination
    /// - direction: direction of pagination
    func updatePaginationState(_ state: PaginationState, at direction: PagingDirection)
}

/// Input signals to control visibility of progressView in header
public protocol TopPaginatableInput: AnyObject {

    /// Call this method to control availability of **loadPrevPage** action
    ///
    /// - parameter canIterate: `true` if want to use first cell will display event to execute **loadPrevPage**action
    func updatePagination(canIterate: Bool)

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
    func onPaginationInitialized(with input: PaginatableInput, at direction: PagingDirection)

    /// Called when collection scrolled to last cell
    ///
    /// - Parameters:
    /// - input: input signals to hide  `progressView` from footer
    /// - direction: direction of pagination
    func loadNextPage(with input: PaginatableInput, at direction: PagingDirection)
}

/// Output signals for loading previous page of content
public protocol TopPaginatableOutput: AnyObject {

    /// Called when collection has setup `TableTopPaginatablePlugin`
    ///
    /// - parameter input: input signals to hide  `progressView` from header
    func onTopPaginationInitialized(with input: TopPaginatableInput)

    /// Called when collection scrolled to first cell
    ///
    /// - parameter input: input signals to hide  `progressView` from header
    func loadPrevPage(with input: TopPaginatableInput)
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
    private var isErrorWasReceived = false
    private var direction: PagingDirection

    // MARK: - Properties

    weak var tableView: UITableView?
    var strategy: PaginationStrategy?

    /// Property which indicating availability of pages
    public private(set) var canIterate = false {
        didSet {
            if canIterate {
                guard progressView.superview == nil else {
                    return
                }
                strategy?.addPafinationView()
            } else {
                guard progressView.superview != nil else {
                    return
                }
                strategy?.removePafinationView()
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

    public override func setup(with manager: BaseTableManager?) {
        self.tableView = manager?.view
        self.strategy?.scrollView = manager?.view
        self.strategy?.progressView = progressView
        self.canIterate = false
        self.output?.onPaginationInitialized(with: self, at: direction)
        self.progressView.setOnRetry { [weak self] in
            guard let input = self, let output = self?.output, let direction = self?.direction else {
                return
            }
            self?.isErrorWasReceived = false
            output.loadNextPage(with: input, at: direction)
        }
    }

    public override func process(event: TableEvent, with manager: BaseTableManager?) {

        switch event {
        case .willDisplayCell(let indexPath):
            if progressView.frame.minY != tableView?.contentSize.height {
                strategy?.setProgressViewFinalFrame()
            }
            guard indexPath == strategy?.getIndexPath(with: manager?.sections), canIterate, !isLoading, !isErrorWasReceived else {
                return
            }
            output?.loadNextPage(with: self, at: direction)
        default:
            break
        }
    }

}

// MARK: - PaginatableInput

extension TablePaginatablePlugin: PaginatableInput {

    public func updatePaginationEnabled(_ canIterate: Bool, at direction: PagingDirection) {
        self.canIterate = canIterate
        self.direction = direction

        strategy?.resetOffset(canIterate: canIterate)
    }

    public func updatePaginationState(_ state: PaginationState, at direction: PagingDirection) {
        switch state {
        case .idle:
            isLoading = false
        case .loading:
            isLoading = true
            strategy?.saveCurrentState()
        case .error(let error):
            isLoading = false
            isErrorWasReceived = true
            progressView.showError(error)
        }
        progressView.showProgress(isLoading)
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
    /// - parameter direction: direction of pagination
    static func topPaginatable(progressView: TablePaginatablePlugin.ProgressView,
                               output: PaginatableOutput,
                               direction: PagingDirection = .backward(.top)) -> TablePaginatablePlugin {
        let plugin = TablePaginatablePlugin(progressView: progressView, with: output, direction: direction)
        plugin.strategy = TopPaginationStrategy()
        return plugin
    }

    static func bottomPaginatable(progressView: TablePaginatablePlugin.ProgressView,
                                  output: PaginatableOutput,
                                  direction: PagingDirection = .forward(.bottom)) -> TablePaginatablePlugin {
        let plugin = TablePaginatablePlugin(progressView: progressView, with: output, direction: direction)
        plugin.strategy = BottomPaginationStrategy()
        return plugin
    }

}
