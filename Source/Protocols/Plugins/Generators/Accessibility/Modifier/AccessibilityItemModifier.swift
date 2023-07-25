//
//  AccessibilityItemModifier.swift
//  ReactiveDataDisplayManager
//
//  Created by korshunov on 04.07.2023.
//

import UIKit

/// Base modifier which handle only `AccessibilityItem` properties
public enum AccessibilityItemModifier: AccessibilityModifier {
    public static let stateTraits: UIAccessibilityTraits = [.selected, .notEnabled]

    public static func modify(item: AccessibilityItem) {
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
            if item.shouldOverrideStateTraits {
                item.accessibilityTraits = traits
            } else {
                item.accessibilityTraits = traits.union(item.accessibilityTraits.intersection(stateTraits))
            }
        }

        if !item.actionsStrategy.isIgnored {
            item.accessibilityCustomActions = item.actionsStrategy.value?.map { $0.action }
        }
    }

    public static func modify(item: AccessibilityItem, generator: AccessibilityStrategyProvider) {
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
            if item.shouldOverrideStateTraits {
                item.accessibilityTraits = traits
            } else {
                item.accessibilityTraits = traits.union(item.accessibilityTraits.intersection(stateTraits))
            }
        }

        if !item.actionsStrategy.isIgnored {
            item.accessibilityCustomActions = item.actionsStrategy.value?.map { $0.action }
        }
    }
}
