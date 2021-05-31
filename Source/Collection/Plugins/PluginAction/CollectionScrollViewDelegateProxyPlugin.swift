//
//  CollectionScrollViewDelegateProxyPlugin.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 11.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

/// Proxy of all `UIScrollViewDelegate` events
public class CollectionScrollViewDelegateProxyPlugin: BaseCollectionPlugin<ScrollEvent> {

    // MARK: - Properties

    public var didScroll = BaseEvent<UICollectionView>()
    public var willBeginDragging = BaseEvent<UICollectionView>()
    public var willEndDragging = BaseEvent<(collectionView: UICollectionView, velocity: CGPoint, targetContentOffset: CGPoint)>()
    public var didEndDragging = BaseEvent<(collectionView: UICollectionView, decelerate: Bool)>()
    public var didScrollToTop = BaseEvent<UICollectionView>()
    public var willBeginDecelerating = BaseEvent<UICollectionView>()
    public var didEndDecelerating = BaseEvent<UICollectionView>()
    public var willBeginZooming = BaseEvent<(collectionView: UICollectionView, view: UIView?)>()
    public var didEndZooming = BaseEvent<(collectionView: UICollectionView, view: UIView?, scale: CGFloat)>()
    public var didZoom = BaseEvent<UICollectionView>()
    public var didEndScrollingAnimation = BaseEvent<UICollectionView>()
    public var didChangeAdjustedContentInset = BaseEvent<UICollectionView>()

    // MARK: - BaseCollectionPlugin

    public override func process(event: ScrollEvent, with manager: BaseCollectionManager?) {
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

public extension BaseCollectionPlugin {

    /// Plugin to proxy of all `UIScrollViewDelegate` events
    static func proxyScroll() -> BaseCollectionPlugin<ScrollEvent> {
        CollectionScrollViewDelegateProxyPlugin()
    }

}
