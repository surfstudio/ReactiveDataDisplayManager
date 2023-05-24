//
//  AccessibilityModifier.swift
//  ReactiveDataDisplayManager
//
//  Created by korshunov on 22.05.2023.
//

import UIKit


public protocol AccessibilityModifier {
    static func modify(view: UIView, with cell: AccessibilityCell, generator: AccessibilityItem?)
}

enum DefaultAccessibilityModifier: AccessibilityModifier {
    static func modify(view: UIView, with cell: AccessibilityCell, generator: AccessibilityItem?) {
        view.isAccessibilityElement = true

        if !cell.labelStrategy.isIgnored || generator?.labelStrategy.isIgnored == false {
            view.accessibilityLabel = cell.accessibilityStrategyConflictResolver(cellStrategy: cell.labelStrategy,
                                                                                 generatorStrategy: generator?.labelStrategy)
        }

        if !cell.valueStrategy.isIgnored || generator?.valueStrategy.isIgnored == false {
            view.accessibilityValue = cell.accessibilityStrategyConflictResolver(cellStrategy: cell.valueStrategy,
                                                                                 generatorStrategy: generator?.valueStrategy)
        }

        if !cell.traitsStrategy.isIgnored || generator?.traitsStrategy.isIgnored == false {
            let traits = [cell.traitsStrategy.value, generator?.traitsStrategy.value]
                .compactMap { $0 }
                .reduce(UIAccessibilityTraits(), { $0.union($1) })
            view.accessibilityTraits = traits
        }
    }
}
