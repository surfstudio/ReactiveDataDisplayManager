//
//  ScrollEvent.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 28.01.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

public enum ScrollEvent {
    case didScroll
    case willEndDragging(CGPoint)
}
