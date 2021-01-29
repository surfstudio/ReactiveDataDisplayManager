//
//  ScrollEvent.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 28.01.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

public enum ScrollEvent {
    case didScroll(UIScrollView)
    case willBeginDragging(UIScrollView)
    case willEndDragging(scrollView: UIScrollView, velocity: CGPoint, targetContentOffset: CGPoint)
    case didEndDragging(UIScrollView, decelerate: Bool)
    case didScrollToTop(UIScrollView)
    case willBeginDecelerating(UIScrollView)
    case didEndDecelerating(UIScrollView)
    case willBeginZooming(scrollView: UIScrollView, view: UIView?)
    case didEndZooming(scrollView: UIScrollView, view: UIView?, scale: CGFloat)
    case didZoom(UIScrollView)
    case didEndScrollingAnimation(UIScrollView)
    case didChangeAdjustedContentInset(UIScrollView)
}
