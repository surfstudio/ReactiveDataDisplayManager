//
//  TableChildrenHolder.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 28.07.2023.
//

import UIKit

public typealias TableChildrenAnimationGroup = (remove: UITableView.RowAnimation, insert: UITableView.RowAnimation)

public protocol TableChildrenHolder: AccessibilityStrategyProvider {

    /// Set animation for folder's expand / shrink
    var animation: TableChildrenAnimationGroup { get set }

    /// Generators describing cells to be inserted in expanded state
    var children: [TableCellGenerator] { get set }

}

// MARK: - Defaults

public extension TableChildrenHolder {
    var animation: TableChildrenAnimationGroup {
        return (.none, .fade)
    }

    var labelStrategy: AccessibilityStringStrategy { .ignored }
    var traitsStrategy: AccessibilityTraitsStrategy { children.isEmpty ? .ignored : .just(.button) }
}
