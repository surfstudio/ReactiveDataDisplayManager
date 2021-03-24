//
//  CollectionEvent.swift
//  ReactiveDataDisplayManager
//
//  Created by Vadim Tikhonov on 09.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

public enum CollectionEvent {
    case didSelect(IndexPath)
    case didDeselect(IndexPath)
    case didHighlight(IndexPath)
    case didUnhighlight(IndexPath)
    case willDisplayCell(IndexPath)
    case didEndDisplayCell(IndexPath)
    case willDisplaySupplementaryView(IndexPath)
    case didEndDisplayingSupplementaryView(IndexPath)
    case move(from: IndexPath, to: IndexPath)
}
