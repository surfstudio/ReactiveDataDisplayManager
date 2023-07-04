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
    case willDisplayCell(IndexPath, UICollectionViewCell)
    case didEndDisplayCell(IndexPath, UICollectionViewCell)
    case willDisplaySupplementaryView(IndexPath, UICollectionReusableView, String)
    case didEndDisplayingSupplementaryView(IndexPath, UICollectionReusableView, String)
    case move(from: IndexPath, to: IndexPath)

    // MARK: - Accessibility Events

    case invalidatedCellAccessibility(IndexPath, AccessibilityItem)
    case invalidatedHeaderAccessibility(Int, AccessibilityItem)
    case invalidatedFooterAccessibility(Int, AccessibilityItem)
}
