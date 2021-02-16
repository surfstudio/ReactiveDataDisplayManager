//
//  TableDirectionScrollablePlugin.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 29.01.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

/// Added support for determining the direction of the scroll
public class TableDirectionScrollablePlugin: BaseTablePlugin<ScrollEvent> {

    // MARK: - Private Properties

    private var lastContentOffset: CGFloat = .zero
    private let action: (ScrollDirection) -> Void

    // MARK: - Initialization

    /// - parameter action: closure returns the scrolling direction
    public init(action: @escaping (ScrollDirection) -> Void) {
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
