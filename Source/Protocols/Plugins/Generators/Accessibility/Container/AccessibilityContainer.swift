//
//  AccessibilityContainer.swift
//  ReactiveDataDisplayManager
//
//  Created by korshunov on 04.07.2023.
//

import Foundation

public protocol AccessibilityContainer: AccessibilityItem {

    /// Child items of this container
    var accessibilityChildItems: [AccessibilityItem] { get }
}

public extension AccessibilityContainer {

    var labelStrategy: AccessibilityStringStrategy { .ignored }

    var actionsStrategy: AccessibilityActionsStrategy { .ignored }

    var modifierType: AccessibilityModifier.Type { AccessibilityContainerModifier.self }
}
