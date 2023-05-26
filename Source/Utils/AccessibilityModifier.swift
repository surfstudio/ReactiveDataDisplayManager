//
//  AccessibilityModifier.swift
//  ReactiveDataDisplayManager
//
//  Created by korshunov on 22.05.2023.
//

import UIKit

/// Protocol for accessibility parameters modifier
public protocol AccessibilityModifier {
    /// Modifies the view with strategies from item and generator
    static func modify(view: UIView, with item: AccessibilityItem, generator: AccessibilityStrategyProvider?)
}

enum DefaultAccessibilityModifier: AccessibilityModifier {
    static func modify(view: UIView, with item: AccessibilityItem, generator: AccessibilityStrategyProvider?) {
        view.isAccessibilityElement = true

        if !item.labelStrategy.isIgnored || generator?.labelStrategy.isIgnored == false {
            view.accessibilityLabel = item.accessibilityStrategyConflictResolver(itemStrategy: item.labelStrategy,
                                                                                 generatorStrategy: generator?.labelStrategy)
        }

        if !item.valueStrategy.isIgnored || generator?.valueStrategy.isIgnored == false {
            view.accessibilityValue = item.accessibilityStrategyConflictResolver(itemStrategy: item.valueStrategy,
                                                                                 generatorStrategy: generator?.valueStrategy)
        }

        if !item.traitsStrategy.isIgnored || generator?.traitsStrategy.isIgnored == false {
            let traits = [item.traitsStrategy.value, generator?.traitsStrategy.value]
                .compactMap { $0 }
                .reduce(UIAccessibilityTraits(), { $0.union($1) })
            view.accessibilityTraits = traits
        }
    }
}
