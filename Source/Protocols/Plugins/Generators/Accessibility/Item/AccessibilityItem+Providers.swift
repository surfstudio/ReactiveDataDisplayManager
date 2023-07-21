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
    var labelStrategy: AccessibilityStringStrategy { get }

    /// strategy for `accessibilityValue`. Default: `.ignored`
    var valueStrategy: AccessibilityStringStrategy { get }

    /// strategy for `accessibilityTraits`.  Default: `.ignored`
    var traitsStrategy: AccessibilityTraitsStrategy { get }

    /// strategy for `accessibilityCustomActions`. Default: `.ignored`
    var actionsStrategy: AccessibilityActionsStrategy { get }

    /// Idicates that `AccessibilityItem` should become an accessibility element. Equals `true` if all strategies is in state `.ignored`
    var isAccessibilityIgnored: Bool { get }
}

public extension AccessibilityStrategyProvider {
    var valueStrategy: AccessibilityStringStrategy { .ignored }
    var traitsStrategy: AccessibilityTraitsStrategy { .ignored }
    var actionsStrategy: AccessibilityActionsStrategy { .ignored }

    var isAccessibilityIgnored: Bool {
        return [
            labelStrategy.isIgnored,
            valueStrategy.isIgnored,
            traitsStrategy.isIgnored,
            actionsStrategy.isIgnored
        ].allSatisfy { $0 }
    }
}
