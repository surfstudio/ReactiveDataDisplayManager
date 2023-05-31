//
//  TableEvent.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 21.01.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

public enum TableEvent {
    case didSelect(IndexPath)
    case didDeselect(IndexPath)
    case didBeginMultipleSelectionInteraction(IndexPath)
    case didEndMultipleSelectionInteraction
    case accessoryButtonTapped(IndexPath)
    case didHighlight(IndexPath)
    case didUnhighlight(IndexPath)
    case willBeginEditing(IndexPath)
    case didEndEditing(IndexPath?)
    case willDisplayCell(IndexPath, UITableViewCell)
    case didEndDisplayCell(IndexPath, UITableViewCell)
    case willDisplayHeader(Int, UIView)
    case didEndDisplayHeader(Int, UIView)
    case willDisplayFooter(Int, UIView)
    case didEndDisplayFooter(Int, UIView)
    case invalidatedCellAccessibility(IndexPath, UITableViewCell)
    case invalidatedHeaderAccessibility(Int, UIView)
    case invalidatedFooterAccessibility(Int, UIView)
    case didUpdateFocus(context: UITableViewFocusUpdateContext, coordinator: UIFocusAnimationCoordinator)
    case move(from: IndexPath, to: IndexPath)
}
