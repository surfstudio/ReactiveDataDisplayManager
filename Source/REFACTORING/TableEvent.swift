//
//  TableEvent.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 21.01.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

public enum TableEvent {
    case didSelect(IndexPath)
    case willDisplayCell(IndexPath)
    case didEndDisplayCell(IndexPath)
    case willDisplayHeader(Int)
    case didEndDisplayHeader(Int)
}