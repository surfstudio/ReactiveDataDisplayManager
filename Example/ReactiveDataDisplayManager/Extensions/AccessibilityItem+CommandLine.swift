//
//  AccessibilityItem+CommandLine.swift
//  ReactiveDataDisplayManagerExample_iOS
//
//  Created by Никита Коробейников on 02.06.2023.
//

import Foundation
import ReactiveDataDisplayManager

extension AccessibilityItem {
    var modifierType: AccessibilityModifierType {
        #if DEBUG
        if CommandLine.arguments.contains("-doNotOverrideTraits") {
            return NoTraitsAccessibilityModifier.self
        } else {
            return BaseAccessibilityModifier.self
        }
        #else
        return BaseAccessibilityModifier.self
        #endif
    }
}

// MARK: - NoTraitsAccessibilityModifier

enum NoTraitsAccessibilityModifier: AccessibilityModifier {

    static func modify(item: AccessibilityItem) {
        let traits = item.accessibilityTraits
        BaseAccessibilityModifier.self.modify(item: item)
        item.accessibilityTraits = traits
    }

    static func modify(item: AccessibilityItem, generator: AccessibilityStrategyProvider) {
        let traits = item.accessibilityTraits
        BaseAccessibilityModifier.self.modify(item: item, generator: generator)
        item.accessibilityTraits = traits
    }

}
