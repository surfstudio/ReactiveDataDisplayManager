//
//  TableScrollablePlugin.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 28.01.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

/// Proxy of all UIScrollViewDelegate events
public class TableScrollViewDelegateProxyPlugin: PluginAction<ScrollEvent, BaseTableStateManager> {

    // MARK: - Properties

    public var didScroll = BaseEvent<UITableView>()
    public var willBeginDragging = BaseEvent<UITableView>()
    public var willEndDragging = BaseEvent<(tableView: UITableView, velocity: CGPoint, targetContentOffset: CGPoint)>()
    public var didEndDragging = BaseEvent<(tableView: UITableView, decelerate: Bool)>()
    public var didScrollToTop = BaseEvent<UITableView>()
    public var willBeginDecelerating = BaseEvent<UITableView>()
    public var didEndDecelerating = BaseEvent<UITableView>()
    public var willBeginZooming = BaseEvent<(tableView: UITableView, view: UIView?)>()
    public var didEndZooming = BaseEvent<(tableView: UITableView, view: UIView?, scale: CGFloat)>()
    public var didZoom = BaseEvent<UITableView>()
    public var didEndScrollingAnimation = BaseEvent<UITableView>()
    public var didChangeAdjustedContentInset = BaseEvent<UITableView>()

    // MARK: - PluginAction

    override func process(event: ScrollEvent, with manager: BaseTableStateManager?) {
        guard let tableView = manager?.tableView else { return }

        switch event {
        case .didScroll:
            didScroll.invoke(with: tableView)
        case .willBeginDragging:
            willBeginDragging.invoke(with: tableView)
        case .willEndDragging(let velocity, let targetContentOffset):
            willEndDragging.invoke(with:(tableView, velocity, targetContentOffset))
        case .didEndDragging(let decelerate):
            didEndDragging.invoke(with:(tableView, decelerate))
        case .didScrollToTop:
            didScrollToTop.invoke(with: tableView)
        case .willBeginDecelerating:
            willBeginDecelerating.invoke(with: tableView)
        case .didEndDecelerating:
            didEndDecelerating.invoke(with: tableView)
        case .willBeginZooming(let view):
            willBeginZooming.invoke(with:(tableView, view))
        case .didEndZooming(let view, let scale):
            didEndZooming.invoke(with:(tableView, view, scale))
        case .didZoom:
            didZoom.invoke(with: tableView)
        case .didEndScrollingAnimation:
            didEndScrollingAnimation.invoke(with: tableView)
        case .didChangeAdjustedContentInset:
            didChangeAdjustedContentInset.invoke(with: tableView)
        }
    }

}
