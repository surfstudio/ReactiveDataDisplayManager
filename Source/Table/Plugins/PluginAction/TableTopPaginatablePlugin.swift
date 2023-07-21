//
//  TableTopPaginatablePlugin.swift
//  ReactiveDataDisplayManager
//
//  Created by Антон Голубейков on 20.06.2023.
//

import UIKit

/// Plugin to display `progressView` while prevous page is loading
///
/// Show `progressView` on `willDisplay` lase cell.
/// Hide `progressView` when finish loading request
///
/// - Warning: Specify estimatedRowHeight of your layout to proper `willDisplay` calls and correct `contentSize`
/// - Warning: UITableView.style must be plain style for keeping scroll position 
public class TableTopPaginatablePlugin: BaseTablePlugin<TableEvent> {

    // MARK: - Nested types

    public typealias ProgressView = UIView & ProgressDisplayableItem

    // MARK: - Private Properties

    private let progressView: ProgressView
    private weak var output: TopPaginatableOutput?
    private let isSaveScrollPositionNeeded: Bool

    private var isLoading = false
    private var isErrorWasReceived = false

    private weak var tableView: UITableView?

    private var currentContentSizeHeight: CGFloat?

    /// Property which indicating availability of pages
    public private(set) var canIterate = false {
        didSet {
            if canIterate {
                tableView?.tableHeaderView = progressView
            } else {
                tableView?.tableHeaderView = nil
            }
        }
    }

    // MARK: - Initialization

    /// - parameter progressView: indicator view to add inside header. Do not forget to init this view with valid frame size.
    /// - parameter output: output signals to hide  `progressView` from header
    init(progressView: ProgressView, with output: TopPaginatableOutput, isSaveScrollPositionNeeded: Bool) {
        self.progressView = progressView
        self.output = output
        self.isSaveScrollPositionNeeded = isSaveScrollPositionNeeded
    }

    // MARK: - BaseTablePlugin

    public override func setup(with manager: BaseTableManager?) {
        self.tableView = manager?.view
        self.canIterate = false
        self.output?.onTopPaginationInitialized(with: self)
        self.progressView.setOnRetry { [weak self] in
            guard let input = self, let output = self?.output else {
                return
            }
            self?.isErrorWasReceived = false
            output.loadPrevPage(with: input)
        }
    }

    public override func process(event: TableEvent, with manager: BaseTableManager?) {

        switch event {
        case .willDisplayCell(let indexPath, _):
            let firstCellIndexPath = IndexPath(row: 0, section: 0)
            if indexPath == firstCellIndexPath && canIterate && !isLoading && !isErrorWasReceived {
                output?.loadPrevPage(with: self)
            }
        default:
            break
        }
    }

}

// MARK: - PaginatableInput

extension TableTopPaginatablePlugin: TopPaginatableInput {

    public func updateProgress(isLoading: Bool) {
        self.isLoading = isLoading
        progressView.showProgress(isLoading)
        if isLoading {
            currentContentSizeHeight = tableView?.contentSize.height
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
            isSaveScrollPositionNeeded,
            let currentContentSizeHeight = currentContentSizeHeight,
            let newContentSizeHeight = tableView?.contentSize.height
        {
            let finalOffset = CGPoint(x: 0, y: newContentSizeHeight - currentContentSizeHeight)
            tableView?.setContentOffset(finalOffset, animated: false)
            self.currentContentSizeHeight = nil
        }
    }

}
