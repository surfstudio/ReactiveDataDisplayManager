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

/// Base modifier which handle only `AccessibilityItem` properties
public enum BaseAccessibilityModifier: AccessibilityModifier {
    static let stateTraits: UIAccessibilityTraits = [.selected, .notEnabled]

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
            if item.shouldOverrideStateTraits {
                item.accessibilityTraits = traits
            } else {
                item.accessibilityTraits = traits.union(item.accessibilityTraits.intersection(stateTraits))
            }
        }

        item.accessibilityCustomActions = item.accessibilityActions()
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
            if item.shouldOverrideStateTraits {
                item.accessibilityTraits = traits
            } else {
                item.accessibilityTraits = traits.union(item.accessibilityTraits.intersection(stateTraits))
            }
        }

        item.accessibilityCustomActions = item.accessibilityActions()

        if let actionsProvider = generator as? AccessibilityActionsProvider {
            item.accessibilityCustomActions?.append(contentsOf: actionsProvider.accessibilityActions())
        }
    }
}

#if DEBUG
/// Special modifier for UI tests, which adds `.button` trait for `UITableViewCell` and `UICollectionViewCell` to make them conform to cell `XCUIElement` type.
/// Also adds trait `.staticText` for headers and footers to make them accessible by identifier
public enum XCUITestsAccessibilityModifier: AccessibilityModifier {

    static public func modify(item: AccessibilityItem) {
        BaseAccessibilityModifier.modify(item: item)
        if item is UITableViewCell || item is UICollectionViewCell {
            item.accessibilityTraits.insert(.button)
        } else {
            item.accessibilityTraits.insert(.staticText)
        }
    }

    static public func modify(item: AccessibilityItem, generator: AccessibilityStrategyProvider) {
        BaseAccessibilityModifier.modify(item: item, generator: generator)
        if item is UITableViewCell || item is UICollectionViewCell {
            item.accessibilityTraits.insert(.button)
        } else {
            item.accessibilityTraits.insert(.staticText)
        }
    }

}
#endif
