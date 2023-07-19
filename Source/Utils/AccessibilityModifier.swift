//
//  AccessibilityModifier.swift
//  ReactiveDataDisplayManager
//
//  Created by korshunov on 22.05.2023.
//

import UIKit

/// Protocol for accessibility parameters modifier
public protocol AccessibilityModifier {
    /// Modifies`AccessibilityItem` with provided strategies from
    static func modify(item: AccessibilityItem)

    /// Modifies `AccessibilityItem` with provided strategies  and `AccessibilityStrategyProvider`
    static func modify(item: AccessibilityItem, generator: AccessibilityStrategyProvider)
}

public enum DefaultAccessibilityModifier: AccessibilityModifier {
    static public func modify(item: AccessibilityItem) {
        guard !item.isAccessibilityIgnored else {
            return
        }
        item.isAccessibilityElement = true

        if !item.labelStrategy.isIgnored {
            item.accessibilityLabel = item.labelStrategy.value
        }

        if !item.valueStrategy.isIgnored {
            item.accessibilityValue = item.valueStrategy.value
        }

        if !item.traitsStrategy.isIgnored, let traits = item.traitsStrategy.value {
            item.accessibilityTraits = traits
        }
    }

    static public func modify(item: AccessibilityItem, generator: AccessibilityStrategyProvider) {
        guard !item.isAccessibilityIgnored || !generator.isAccessibilityIgnored else {
            return
        }
        item.isAccessibilityElement = true

        if !item.labelStrategy.isIgnored || !generator.labelStrategy.isIgnored {
            item.accessibilityLabel = item.accessibilityStrategyConflictResolver(itemStrategy: item.labelStrategy,
                                                                                 generatorStrategy: generator.labelStrategy)
        }

        if !item.valueStrategy.isIgnored || !generator.valueStrategy.isIgnored {
            item.accessibilityValue = item.accessibilityStrategyConflictResolver(itemStrategy: item.valueStrategy,
                                                                                 generatorStrategy: generator.valueStrategy)
        }

        if !item.traitsStrategy.isIgnored || !generator.traitsStrategy.isIgnored {
            let traits = [item.traitsStrategy.value, generator.traitsStrategy.value]
                .compactMap { $0 }
                .reduce(UIAccessibilityTraits(), { $0.union($1) })
            item.accessibilityTraits = traits
        }
    }
}
