//
//  TableDirectionScrollablePlugin.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 29.01.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

/// Plugin to determine current `ScrollDirection`
public class TableDirectionScrollablePlugin: BaseTablePlugin<ScrollEvent> {

    public typealias Action = (ScrollDirection) -> Void

    // MARK: - Private Properties

    private var lastContentOffset: CGFloat = .zero
    private let action: Action

    // MARK: - Initialization

    /// - parameter action: closure returns the scrolling direction
    init(action: @escaping Action) {
        self.action = action
    }

    // MARK: - BaseTablePlugin

    public override func process(event: ScrollEvent, with manager: BaseTableManager?) {
        guard let tableView = manager?.view else { return }

        switch event {
        case .willBeginDragging:
            lastContentOffset = tableView.contentOffset.y
        case .didScroll:
            if lastContentOffset > tableView.contentOffset.y {
                action(.up)
            } else if lastContentOffset < tableView.contentOffset.y {
                action(.down)
            }
        default:
            break
        }
    }

}

// MARK: - Public init

public extension BaseTablePlugin {

    /// Plugin to determine current `ScrollDirection`
    ///
    /// - parameter action: closure returns the scrolling direction
    static func direction(action: @escaping TableDirectionScrollablePlugin.Action) -> TableDirectionScrollablePlugin {
        .init(action: action)
    }

}
