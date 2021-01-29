//
//  TableDirectionScrollablePlugin.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 29.01.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

/// Added support for determining the direction of the scroll
public class TableDirectionScrollablePlugin: PluginAction<ScrollEvent, BaseTableStateManager> {

    // MARK: - Properties

    public private(set) var userDidScrolled = false
    public var onScrollUp = BaseEmptyEvent()
    public var onScrollDown = BaseEmptyEvent()

    // MARK: - Private Properties

    private var lastContentOffset: CGFloat = 0

    // MARK: - PluginAction

    override func process(event: ScrollEvent, with manager: BaseTableStateManager?) {
        switch event {
        case .willBeginDragging(let scrollView):
            lastContentOffset = scrollView.contentOffset.y
        case .didScroll(let scrollView):
            if lastContentOffset > scrollView.contentOffset.y {
                onScrollUp.invoke()
            } else if lastContentOffset < scrollView.contentOffset.y {
                onScrollDown.invoke()
            }

            if !userDidScrolled {
                userDidScrolled = true
            }
        default:
            break
        }
    }

}
