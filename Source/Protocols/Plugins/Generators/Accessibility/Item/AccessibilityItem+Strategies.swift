//
//  AccessibilityStrategies.swift
//  ReactiveDataDisplayManager
//
//  Created by korshunov on 31.05.2023.
//

import UIKit

public struct AccessibilityStrategy<ValueType> {

    public var value: ValueType?
    public var isIgnored: Bool

    /// value will not be changed by this strategy
    public static var ignored: Self {
        return .init(nil, isIgnored: true)
    }

    public init(_ value: ValueType?, isIgnored: Bool = false) {
        self.value = value
        self.isIgnored = isIgnored
    }

    /// just a value
    public static func just(_ value: ValueType?) -> Self {
        return .init(value)
    }

    /// a reference value from object.
    /// - parameter keyPath: specified keypath from value would be taken.
    public static func from<T>(_ object: T, keyPath: KeyPath<T, ValueType?>) -> Self {
        return .init(object[keyPath: keyPath])
    }

    /// a reference value from object.
    /// - parameter keyPath: specified keypath from value would be taken.
    public static func from<T>(_ object: T, keyPath: KeyPath<T, ValueType>) -> Self {
        return .init(object[keyPath: keyPath])
    }
}

public typealias AccessibilityStringStrategy = AccessibilityStrategy<String>

public extension AccessibilityStrategy where ValueType == String {

    /// a combination of strings
    static func merge(_ values: ValueType?..., separator: String = "") -> Self {
        return .init(values.compactMap { $0 }.joined(separator: separator))
    }

}

public typealias AccessibilityTraitsStrategy = AccessibilityStrategy<UIAccessibilityTraits>

public extension AccessibilityStrategy where ValueType == UIAccessibilityTraits {

    /// a reference traits merged from specified objects
    static func merge(objects: NSObject...) -> Self {
        let traits = objects.map(\.accessibilityTraits).reduce(UIAccessibilityTraits(), { $0.union($1) })
        return .init(traits)
    }

}
