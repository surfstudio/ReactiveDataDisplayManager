//
//  AccessibilityItem+Providers.swift
//  ReactiveDataDisplayManager
//
//  Created by korshunov on 31.05.2023.
//

import UIKit

/// Accessibility strategies provider protocol for generators
public protocol AccessibilityStrategyProvider {

    /// strategy for `accessibilityLabel`
    var labelStrategy: AccessibilityStrategy<String> { get }

    /// strategy for `accessibilityValue`. Default: `.ignored`
    var valueStrategy: AccessibilityStrategy<String> { get }

    /// strategy for `accessibilityTraits`.  Default: `.ignored`
    var traitsStrategy: AccessibilityStrategy<UIAccessibilityTraits> { get }

    /// Idicates that `AccessibilityItem` should become an accessibility element. Equals `true` if all strategies is in state `.ignored`
    var isAccessibilityIgnored: Bool { get }
}

public extension AccessibilityStrategyProvider {
    var valueStrategy: AccessibilityStrategy<String> { .ignored }
    var traitsStrategy: AccessibilityStrategy<UIAccessibilityTraits> { .ignored }

    var isAccessibilityIgnored: Bool {
        return [labelStrategy.isIgnored, valueStrategy.isIgnored, traitsStrategy.isIgnored].allSatisfy { $0 }
    }
}

/// `UIAccessibilityCustomAction`'s provider
public protocol AccessibilityActionsProvider {
    func accessibilityActions() -> [UIAccessibilityCustomAction]
}

/// `AccessibilityItem`default actions
public extension AccessibilityItem {
    func accessibilityActions() -> [UIAccessibilityCustomAction] { [] }
}
