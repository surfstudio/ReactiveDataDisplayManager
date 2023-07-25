//
//  AccessibilityItem.swift
//  ReactiveDataDisplayManager
//
//  Created by korshunov on 22.05.2023.
//

import UIKit

/// Protocol for cells to adopt accesibility
public protocol AccessibilityItem: UIResponder, AccessibilityStrategyProvider {

    typealias AccessibilityModifierType = AccessibilityModifier.Type

    /// Type of modifier that will be used to apply strategies to view. Default it's internal implementation
    ///
    /// You can provide your own type of `AccessibilityModifier` implementation to change the way how stategies applied to view.
    /// Also `AccessibilityStrategyProvider` can be extended by your protocol to add new parameters. And to apply new parameters you need to provide a custom modifier
    var modifierType: AccessibilityModifierType { get }

    /// Defines the behaviour for traits `[.selected, .notEnabled]`. By default, modifier will not override these traits
    var shouldOverrideStateTraits: Bool { get }

    /// Conficts resolver when generator and item contains `AccessibilityStringStrategy`. By default values will be joined with a space separator in next order: generator, item
    ///
    /// You can define your own implementation to change separator or order of values.
    /// - parameter itemStrategy: strategy defined in cell
    /// - parameter generatorStrategy: stategy provided  from cell's generator
    /// - returns: value combined from both strategies
    func accessibilityStrategyConflictResolver(itemStrategy: AccessibilityStringStrategy,
                                               generatorStrategy: AccessibilityStringStrategy) -> String?
}

public extension AccessibilityItem {

    var modifierType: AccessibilityModifierType {
        #if DEBUG
        if CommandLine.arguments.contains("-rddm.XCUITestsCompatible") {
            return XCUITestsAccessibilityModifier.self
        } else {
            return AccessibilityItemModifier.self
        }
        #else
        return AccessibilityItemModifier.self
        #endif
    }

    var shouldOverrideStateTraits: Bool { false }

    func accessibilityStrategyConflictResolver(itemStrategy: AccessibilityStringStrategy,
                                               generatorStrategy: AccessibilityStringStrategy) -> String? {
        return [generatorStrategy, itemStrategy].compactMap(\.value).joined(separator: " ")
    }

    /// Shortcut to modify self with default modifier
    func modifySelf() {
        self.modifierType.modify(item: self)
    }

    /// Shortcut to modify self with additional strategy
    ///  - parameter additionalStrategy: additional strategy provider to apply (most probably generator)
    func modifySelf(with additionalStrategy: AccessibilityStrategyProvider) {
        self.modifierType.modify(item: self, generator: additionalStrategy)
    }
}
