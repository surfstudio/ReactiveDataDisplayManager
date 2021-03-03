//
//  TableRefreshablePlugin.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 03.03.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

/// Plugin to show and hide `refreshControl`
public class TableRefreshablePlugin: BaseTablePlugin<ScrollEvent> {

    public typealias RefreshableAction = () -> Void

    // MARK: - Private Properties

    private let refreshControl: UIRefreshControl
    private let action: RefreshableAction

    // MARK: - Initialization

    /// - parameter refreshControl: closure with reaction to visibility of last cell
    /// - parameter action: closure with reaction to visibility of last cell
    init(refreshControl: UIRefreshControl, action: @escaping RefreshableAction) {
        self.refreshControl = refreshControl
        self.action = action
    }

    // MARK: - BaseTablePlugin

    public override func process(event: ScrollEvent, with manager: BaseTableManager?) {

        switch event {
        case .willEndDragging:
            if refreshControl.isRefreshing {
                action()
            }
        default:
            break
        }
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
    /// - parameter action: closure with reaction to visibility of last cell
    static func refreshable(refreshControl: UIRefreshControl,
                            action: @escaping TableRefreshablePlugin.RefreshableAction) -> TableRefreshablePlugin {
        .init(refreshControl: refreshControl, action: action)
    }

}
