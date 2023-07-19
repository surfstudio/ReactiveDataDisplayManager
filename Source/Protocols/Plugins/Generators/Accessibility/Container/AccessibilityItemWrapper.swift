//
//  AccessibilityItemWrapper.swift
//  ReactiveDataDisplayManager
//
//  Created by korshunov on 04.07.2023.
//

import UIKit

/// `AccessibilityItem` wrapper for views that cannot be changed
open class AccessibilityItemWrapper: UIAccessibilityElement, AccessibilityItem {

    open var labelStrategy: AccessibilityStringStrategy
    open var valueStrategy: AccessibilityStringStrategy
    open var traitsStrategy: AccessibilityTraitsStrategy
    open var actionsStrategy: AccessibilityActionsStrategy

    open var shouldOverrideStateTraits: Bool = false
    open var modifierType: AccessibilityModifierType = AccessibilityItemModifier.self

    required public init(
        parentView: UIView
    ) {
        self.labelStrategy = .ignored
        self.valueStrategy = .ignored
        self.traitsStrategy = .ignored
        self.actionsStrategy = .ignored
        super.init(accessibilityContainer: parentView)
    }

    public init(
        parentView: UIView,
        labelStrategy: AccessibilityStringStrategy,
        valueStrategy: AccessibilityStringStrategy = .ignored,
        traitsStrategy: AccessibilityTraitsStrategy = .ignored,
        actionsStrategy: AccessibilityActionsStrategy = .ignored
    ) {
        self.labelStrategy = labelStrategy
        self.valueStrategy = valueStrategy
        self.traitsStrategy = traitsStrategy
        self.actionsStrategy = actionsStrategy
        super.init(accessibilityContainer: parentView)
    }

}
