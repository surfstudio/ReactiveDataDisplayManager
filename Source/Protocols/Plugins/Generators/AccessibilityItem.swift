//
//  AccessibilityItem.swift
//  ReactiveDataDisplayManager
//
//  Created by korshunov on 22.05.2023.
//

import UIKit

/// Default accessibility strategy for string value
public enum AccessibilityStringStrategy {

    /// value will not be change by this strategy
    case ignored

    /// simple string value, can be nil
    case just(String?)

    /// a reference value from object. By default it's `accessibilityLabel`
    /// - parameter keyPath: specified keypath from value would be taken
    case from(object: NSObject, keyPath: KeyPath<NSObject, String?> = \.accessibilityLabel)

    /// a combination of strategies, joined by provided separator
    indirect case joined([AccessibilityStringStrategy], separator: String)

    var isIgnored: Bool {
        if case .ignored = self {
            return true
        } else {
            return false
        }
    }

    var value: String? {
        switch self {
        case .ignored:
            return nil
        case .just(let string):
            return string
        case .from(let object, let keyPath):
            return object[keyPath: keyPath]
        case .joined(let strategies, let separator):
            return strategies.compactMap(\.value).joined(separator: separator)
        }
    }
}

/// Accessibility strategy for `UIAccessibilityTraits` parameter
public enum AccessibilityTraitsStrategy {

    /// value will not be change by this strategy
    case ignored

    /// simple accessibility traits
    case just(UIAccessibilityTraits)

    /// a reference traits from another object
    case from(object: NSObject)

    /// a reference traits merged from another objects
    case merge([NSObject])

    var isIgnored: Bool {
        if case .ignored = self {
            return true
        } else {
            return false
        }
    }

    /// accessibility traits of current strategy
    /// - Returns: nil if `isIgnored`, otherwise `UIAccessibilityTraits`
    var value: UIAccessibilityTraits? {
        switch self {
        case .ignored:
            return nil
        case .just(let traits):
            return traits
        case .from(let object):
            return object.accessibilityTraits
        case .merge(let objects):
            return objects.map(\.accessibilityTraits).reduce(UIAccessibilityTraits(), { $0.union($1) })
        }
    }
}

/// Accessibility strategies provider protocol for generators
public protocol AccessibilityStrategyProvider {

    /// strategy for `accessibilityLabel`. Default: `.ignored`
    var labelStrategy: AccessibilityStringStrategy { get }

    /// strategy for `accessibilityValue`. Default: `.ignored`
    var valueStrategy: AccessibilityStringStrategy { get }

    /// strategy for `accessibilityTraits`. Default: `.ignored`
    var traitsStrategy: AccessibilityTraitsStrategy { get }

    /// Idicates that `AccessibilityItem` should become an accessibility element. Equals `true` if all strategies is in state `.ignored`
    var isAccessibilityIgnored: Bool { get }
}

public extension AccessibilityStrategyProvider {
    var labelStrategy: AccessibilityStringStrategy { .ignored }
    var valueStrategy: AccessibilityStringStrategy { .ignored }
    var traitsStrategy: AccessibilityTraitsStrategy { .ignored }
    var isAccessibilityIgnored: Bool {
        return [labelStrategy.isIgnored, valueStrategy.isIgnored, traitsStrategy.isIgnored].allSatisfy { $0 }
    }
}

public protocol AccessibilityActionsProvider {
    func accessibilityActions() -> [UIAccessibilityCustomAction]
}

/// Protocol for cells to adopt accesibility
public protocol AccessibilityItem: UIView, AccessibilityStrategyProvider & AccessibilityActionsProvider {
    typealias AccessibilityModifierType = AccessibilityModifier.Type

    /// Type of modifier that will be used to apply strategies to view. Default it's internal implementation
    ///
    /// You can provide your own type of `AccessibilityModifier` implementation to change the way how stategies applied to view.
    /// Also `AccessibilityStrategyProvider` can be extended by your protocol to add new parameters. And to apply new parameters you need to provide a custom modifier
    var modifierType: AccessibilityModifierType { get }

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
    var modifierType: AccessibilityModifierType { BaseAccessibilityModifier.self }

    func accessibilityStrategyConflictResolver(itemStrategy: AccessibilityStringStrategy,
                                               generatorStrategy: AccessibilityStringStrategy) -> String? {
        return [generatorStrategy, itemStrategy].compactMap(\.value).joined(separator: " ")
    }

    func accessibilityActions() -> [UIAccessibilityCustomAction] { [] }
}
