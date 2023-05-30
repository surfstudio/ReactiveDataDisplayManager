//
//  AccessibilityModifier.swift
//  ReactiveDataDisplayManager
//
//  Created by korshunov on 22.05.2023.
//

import UIKit

/// Protocol for accessibility parameters modifier
public protocol AccessibilityModifier {
    /// Modifies the view with strategies from `AccessibilityItem`
    static func modify(view: UIView, with item: AccessibilityItem)

    /// Modifies the view with strategies from `AccessibilityItem` and `AccessibilityStrategyProvider`
    static func modify(view: UIView, with item: AccessibilityItem, generator: AccessibilityStrategyProvider)
}

enum DefaultAccessibilityModifier: AccessibilityModifier {

    static func modify(view: UIView, with item: AccessibilityItem) {
        guard !item.isAccessibilityIgnored else {
            return
        }
        view.isAccessibilityElement = true
        view.accessibilityLabel = item.labelStrategy.value
        view.accessibilityValue = item.valueStrategy.value
        view.accessibilityTraits = item.traitsStrategy.value ?? .none
    }

    static func modify(view: UIView, with item: AccessibilityItem, generator: AccessibilityStrategyProvider) {
        guard !item.isAccessibilityIgnored || !generator.isAccessibilityIgnored else {
            return
        }
        view.isAccessibilityElement = true

        if !item.labelStrategy.isIgnored || !generator.labelStrategy.isIgnored {
            view.accessibilityLabel = item.accessibilityStrategyConflictResolver(itemStrategy: item.labelStrategy,
                                                                                 generatorStrategy: generator.labelStrategy)
        }

        if !item.valueStrategy.isIgnored || !generator.valueStrategy.isIgnored {
            view.accessibilityValue = item.accessibilityStrategyConflictResolver(itemStrategy: item.valueStrategy,
                                                                                 generatorStrategy: generator.valueStrategy)
        }

        if !item.traitsStrategy.isIgnored || !generator.traitsStrategy.isIgnored {
            let traits = [item.traitsStrategy.value, generator.traitsStrategy.value]
                .compactMap { $0 }
                .reduce(UIAccessibilityTraits(), { $0.union($1) })
            view.accessibilityTraits = traits
        }
    }
}
