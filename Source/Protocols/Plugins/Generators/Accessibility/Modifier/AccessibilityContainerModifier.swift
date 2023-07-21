//
//  AccessibilityContainerModifier.swift
//  ReactiveDataDisplayManager
//
//  Created by korshunov on 04.07.2023.
//

import Foundation

public enum AccessibilityContainerModifier: AccessibilityModifier {

    public static func modify(item: AccessibilityItem) {
        guard let item = item as? AccessibilityContainer else {
            return
        }

        item.isAccessibilityElement = !item.isAccessibilityIgnored

        item.accessibilityChildItems.forEach {
            $0.modifySelf()
        }
    }

    public static func modify(item: AccessibilityItem, generator: AccessibilityStrategyProvider) {
        // generator is not supported for containers
        modify(item: item)
    }

}
