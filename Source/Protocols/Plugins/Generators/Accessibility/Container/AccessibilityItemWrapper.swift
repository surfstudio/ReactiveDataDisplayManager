//
//  AccessibilityItemWrapper.swift
//  ReactiveDataDisplayManager
//
//  Created by korshunov on 04.07.2023.
//

import UIKit

/// `AccessibilityItem` wrapper for views that cannot be changed
open class AccessibilityItemWrapper: UIAccessibilityElement, AccessibilityItem {

    open var labelStrategy: AccessibilityStrategy<String>
    open var valueStrategy: AccessibilityStrategy<String>
    open var traitsStrategy: AccessibilityStrategy<UIAccessibilityTraits>

    open var shouldOverrideStateTraits: Bool = false
    open var modifierType: AccessibilityModifierType = AccessibilityItemModifier.self

    required public init(
        parentView: UIView,
        labelStrategy: AccessibilityStrategy<String>,
        valueStrategy: AccessibilityStrategy<String> = .ignored,
        traitsStrategy: AccessibilityStrategy<UIAccessibilityTraits> = .ignored
    ) {
        self.labelStrategy = labelStrategy
        self.valueStrategy = valueStrategy
        self.traitsStrategy = traitsStrategy
        super.init(accessibilityContainer: parentView)
    }

}
