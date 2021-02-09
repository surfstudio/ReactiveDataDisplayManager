//
//  CollectionEvent.swift
//  ReactiveDataDisplayManager
//
//  Created by Vadim Tikhonov on 09.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

public enum CollectionEvent {
    case didSelect(IndexPath)
    case didDeselect(IndexPath)
    case didHighlight(IndexPath)
    case didUnhighlight(IndexPath)
    case willDisplayCell(IndexPath)
    case didEndDisplayCell(IndexPath)
    case willDisplaySupplementaryView(IndexPath)
    case didEndDisplayingSupplementaryView(IndexPath)
}
