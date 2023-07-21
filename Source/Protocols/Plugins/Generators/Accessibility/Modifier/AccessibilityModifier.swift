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
