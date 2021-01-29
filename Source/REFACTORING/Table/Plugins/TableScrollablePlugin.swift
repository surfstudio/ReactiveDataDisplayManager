//
//  TableScrollablePlugin.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 28.01.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

/// Added support for scrollViewDelegate events
public class TableScrollablePlugin: PluginAction<ScrollEvent, BaseTableStateManager> {

    // MARK: - Properties

    public var didScroll = BaseEvent<UIScrollView>()
    public var willBeginDragging = BaseEvent<UIScrollView>()
    public var willEndDragging = BaseEvent<(scrollView: UIScrollView, velocity: CGPoint, targetContentOffset: CGPoint)>()
    public var didEndDragging = BaseEvent<(scrollView: UIScrollView, decelerate: Bool)>()
    public var didScrollToTop = BaseEvent<UIScrollView>()
    public var willBeginDecelerating = BaseEvent<UIScrollView>()
    public var didEndDecelerating = BaseEvent<UIScrollView>()
    public var willBeginZooming = BaseEvent<(scrollView: UIScrollView, view: UIView?)>()
    public var didEndZooming = BaseEvent<(scrollView: UIScrollView, view: UIView?, scale: CGFloat)>()
    public var didZoom = BaseEvent<UIScrollView>()
    public var didEndScrollingAnimation = BaseEvent<UIScrollView>()
    public var didChangeAdjustedContentInset = BaseEvent<UIScrollView>()

    // MARK: - PluginAction

    override func process(event: ScrollEvent, with manager: BaseTableStateManager?) {
        switch event {
        case .didScroll(let scrollView):
            didScroll.invoke(with: scrollView)
        case .willBeginDragging(let scrollView):
            willBeginDragging.invoke(with: scrollView)
        case .willEndDragging(let scrollView, let velocity, let targetContentOffset):
            willEndDragging.invoke(with:(scrollView, velocity, targetContentOffset))
        case .didEndDragging(let scrollView, let decelerate):
            didEndDragging.invoke(with:(scrollView, decelerate))
        case .didScrollToTop(let scrollView):
            didScrollToTop.invoke(with: scrollView)
        case .willBeginDecelerating(let scrollView):
            willBeginDecelerating.invoke(with: scrollView)
        case .didEndDecelerating(let scrollView):
            didEndDecelerating.invoke(with: scrollView)
        case .willBeginZooming(let scrollView, let view):
            willBeginZooming.invoke(with:(scrollView, view))
        case .didEndZooming(let scrollView, let view, let scale):
            didEndZooming.invoke(with:(scrollView, view, scale))
        case .didZoom(let scrollView):
            didZoom.invoke(with: scrollView)
        case .didEndScrollingAnimation(let scrollView):
            didEndScrollingAnimation.invoke(with: scrollView)
        case .didChangeAdjustedContentInset(let scrollView):
            didChangeAdjustedContentInset.invoke(with: scrollView)
        }
    }

}
