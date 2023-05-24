//
//  AccessibilityItem.swift
//  ReactiveDataDisplayManager
//
//  Created by korshunov on 22.05.2023.
//

import UIKit

public enum AccessibilityStrategy {
    case ignored
    case just(String?)
    case from(NSObject, keyPath: KeyPath<NSObject, String?> = \.accessibilityLabel)
    indirect case joined([AccessibilityStrategy], separator: String)

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

public enum AccessibilityTraitsStrategy {
    case ignored
    case just(UIAccessibilityTraits)
    case from(NSObject)
    case merge([NSObject])

    var isIgnored: Bool {
        if case .ignored = self {
            return true
        } else {
            return false
        }
    }

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

public protocol AccessibilityItem {
    var labelStrategy: AccessibilityStrategy { get }
    var valueStrategy: AccessibilityStrategy { get }
    var traitsStrategy: AccessibilityTraitsStrategy { get }
}

public extension AccessibilityItem {
    var labelStrategy: AccessibilityStrategy { .ignored }
    var valueStrategy: AccessibilityStrategy { .ignored }
    var traitsStrategy: AccessibilityTraitsStrategy { .ignored }
}

public protocol AccessibilityCell: AccessibilityItem {
    typealias AccessibilityModifierType = AccessibilityModifier.Type
    var modifierType: AccessibilityModifierType { get }

    func accessibilityStrategyConflictResolver(cellStrategy: AccessibilityStrategy, generatorStrategy: AccessibilityStrategy?) -> String?
}

public extension AccessibilityCell {
    var modifierType: AccessibilityModifierType { DefaultAccessibilityModifier.self }

    func accessibilityStrategyConflictResolver(cellStrategy: AccessibilityStrategy, generatorStrategy: AccessibilityStrategy?) -> String? {
        return [generatorStrategy?.value, cellStrategy.value].compactMap { $0 }.joined(separator: " ")
    }
}
