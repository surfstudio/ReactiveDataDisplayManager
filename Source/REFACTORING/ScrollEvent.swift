//
//  ScrollEvent.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 28.01.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

public enum ScrollEvent {
    case didScroll
    case willBeginDragging
    case willEndDragging(velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    case didEndDragging(Bool)
    case didScrollToTop
    case willBeginDecelerating
    case didEndDecelerating
    case willBeginZooming(UIView?)
    case didEndZooming(view: UIView?, scale: CGFloat)
    case didZoom
    case didEndScrollingAnimation
    case didChangeAdjustedContentInset
}
