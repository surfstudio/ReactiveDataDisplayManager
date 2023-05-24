//
//  AccessibilityModifier.swift
//  ReactiveDataDisplayManager
//
//  Created by korshunov on 22.05.2023.
//

import UIKit


public protocol AccessibilityModifier {
    static func modify(view: UIView, with item: AccessibilityItem)
}

enum DefaultAccessibilityModifier: AccessibilityModifier {

    static func modify(view: UIView, with item: AccessibilityItem) {
        view.isAccessibilityElement = true

        if !item.labelStrategy.isIgnored {
            view.accessibilityLabel = item.labelStrategy.value
        }

        if !item.valueStrategy.isIgnored {
            view.accessibilityValue = item.valueStrategy.value
        }

        if !item.traitsStrategy.isIgnored, let traits = item.traitsStrategy.value {
            view.accessibilityTraits.insert(traits)
        }
    }

}
