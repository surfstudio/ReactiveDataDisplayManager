//
//  TableRefreshablePlugin.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 03.03.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//
#if os(iOS)
import UIKit

/// Input signals to hide `UIRefreshControl`
public protocol RefreshableInput: AnyObject {

    /// Call it to hide `UIRefreshControl`
    func endRefreshing()
}

/// Output signals to refresh content
public protocol RefreshableOutput: AnyObject {

    /// Called when  `UIRefreshControl` is activated
    ///
    /// - parameter input: input signals to hide  `UIRefreshControl` on loading finished
    func refreshContent(with input: RefreshableInput)
}

/// Plugin to show and hide `refreshControl`
@available(iOS 10, *)
public class TableRefreshablePlugin: BaseTablePlugin<ScrollEvent> {

    // MARK: - Private Properties

    private let refreshControl: UIRefreshControl
    private weak var output: RefreshableOutput?

    private var isRefreshingStarted = false

    // MARK: - Initialization

    /// - parameter refreshControl: closure with reaction to visibility of last cell
    /// - parameter output: output signals to notify about refreshing
    init(refreshControl: UIRefreshControl, with output: RefreshableOutput) {
        self.refreshControl = refreshControl
        self.output = output
    }

    // MARK: - BaseTablePlugin

    public override func setup(with manager: BaseTableManager?) {
        manager?.view.refreshControl = refreshControl
    }

    public override func process(event: ScrollEvent, with manager: BaseTableManager?) {

        switch event {
        case .willEndDragging:
            if refreshControl.isRefreshing && !isRefreshingStarted {
                output?.refreshContent(with: self)
                isRefreshingStarted = true
            }
        default:
            break
        }
    }

}

// MARK: - RefreshableInput

@available(iOS 10, *)
extension TableRefreshablePlugin: RefreshableInput {

    public func endRefreshing() {
        refreshControl.endRefreshing()
        isRefreshingStarted = false
    }

}

// MARK: - Public init

public extension BaseTablePlugin {

    /// Plugin to show and hide `refreshControl`
    ///
    /// Show `refreshControl` on refreshing
    /// Hide `refreshControl` when finish loading request
    ///
    /// - parameter refreshControl: closure with reaction to visibility of last cell
    /// - parameter output: output signals to notify about refreshing
    @available(iOS 10, *)
    static func refreshable(refreshControl: UIRefreshControl,
                            output: RefreshableOutput) -> TableRefreshablePlugin {
        .init(refreshControl: refreshControl, with: output)
    }

}
#endif
