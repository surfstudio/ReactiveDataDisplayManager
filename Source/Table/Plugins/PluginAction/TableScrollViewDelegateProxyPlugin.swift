//
//  TableScrollViewDelegateProxyPlugin.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 28.01.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

/// Proxy of all `UIScrollViewDelegate` events
public class TableScrollViewDelegateProxyPlugin: BaseTablePlugin<ScrollEvent> {

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

    // MARK: - BaseTablePlugin

    public override func process(event: ScrollEvent, with manager: BaseTableManager?) {
        guard let view = manager?.view else { return }

        switch event {
        case .didScroll:
            didScroll.invoke(with: view)
        case .willBeginDragging:
            willBeginDragging.invoke(with: view)
        case .willEndDragging(let velocity, let targetContentOffset):
            willEndDragging.invoke(with: (view, velocity, targetContentOffset.pointee))
        case .didEndDragging(let decelerate):
            didEndDragging.invoke(with: (view, decelerate))
        case .didScrollToTop:
            didScrollToTop.invoke(with: view)
        case .willBeginDecelerating:
            willBeginDecelerating.invoke(with: view)
        case .didEndDecelerating:
            didEndDecelerating.invoke(with: view)
        case .willBeginZooming(let zoomedView):
            willBeginZooming.invoke(with: (view, zoomedView))
        case .didEndZooming(let zoomedView, let scale):
            didEndZooming.invoke(with: (view, zoomedView, scale))
        case .didZoom:
            didZoom.invoke(with: view)
        case .didEndScrollingAnimation:
            didEndScrollingAnimation.invoke(with: view)
        case .didChangeAdjustedContentInset:
            didChangeAdjustedContentInset.invoke(with: view)
        }
    }

}

// MARK: - Public init

public extension BaseTablePlugin {

    /// Plugin to proxy of all `UIScrollViewDelegate` events
    static func proxyScroll() -> TableScrollViewDelegateProxyPlugin {
        .init()
    }

}
