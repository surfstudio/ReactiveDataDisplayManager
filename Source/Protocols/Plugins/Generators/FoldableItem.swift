//
//  FoldableItem.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 20.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

/// Protocol for cells to handle `isExpanded` state
public protocol FoldableStateHolder: AnyObject {
    func setExpanded(_ isExpanded: Bool)
}

/// Protocol for `TableCellGenerator` to manage expand/collapse state
public protocol FoldableItem: AnyObject, AccessibilityStrategyProvider {

    /// Set animation for folder's expand / shrink
    var animation: TableFoldablePlugin.AnimationGroup { get }

    /// Invokes when cell `didSelect`
    var didFoldEvent: BaseEvent<Bool> { get }

    /// `true` if cell where expanded, `false` if cell where collapsed
    var isExpanded: Bool { get set }

    /// Generators describing cells to be inserted in expanded state
    var childGenerators: [TableCellGenerator] { get set }

}

public extension FoldableItem {
    var animation: TableFoldablePlugin.AnimationGroup {
        return (.none, .fade)
    }

    var labelStrategy: AccessibilityStringStrategy { .ignored }
    var traitsStrategy: AccessibilityTraitsStrategy { childGenerators.isEmpty ? .ignored : .just(.button) }
}
