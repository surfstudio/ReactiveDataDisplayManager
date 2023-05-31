//
//  AccessibilityStrategies.swift
//  ReactiveDataDisplayManager
//
//  Created by korshunov on 31.05.2023.
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

    /// a combination of strategies
    indirect case joined([AccessibilityStringStrategy])

    public var isIgnored: Bool {
        if case .ignored = self {
            return true
        } else {
            return false
        }
    }

    public var value: String? {
        switch self {
        case .ignored:
            return nil
        case .just(let string):
            return string
        case .from(let object, let keyPath):
            return object[keyPath: keyPath]
        case .joined(let strategies):
            return strategies.compactMap(\.value).joined()
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

    public var isIgnored: Bool {
        if case .ignored = self {
            return true
        } else {
            return false
        }
    }

    /// accessibility traits of current strategy
    /// - Returns: nil if `isIgnored`, otherwise `UIAccessibilityTraits`
    public var value: UIAccessibilityTraits? {
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
