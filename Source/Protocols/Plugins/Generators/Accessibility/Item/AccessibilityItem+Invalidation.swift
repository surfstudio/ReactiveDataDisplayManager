//
//  AccessibilityItem+Invalidation.swift
//  ReactiveDataDisplayManager
//
//  Created by korshunov on 31.05.2023.
//

import Foundation

/// Type of `AccessibilityItem` with provided index
public enum AccessibilityItemKind {
    case header(Int), cell(IndexPath), footer(Int)
}

public protocol AccessibilityItemInvalidator {
    /// Invalidates and sets all accessibility parameters for on-screen item
    func invalidateParameters()
}

/// Invalidator which will delegate invalidation to `AccessibilityItemDelegate` to combine item with generator
open class DelegatedAccessibilityItemInvalidator: AccessibilityItemInvalidator {
    let accessibilityItemKind: AccessibilityItemKind
    weak var item: AccessibilityItem?
    weak var accessibilityDelegate: AccessibilityItemDelegate?

    /// - Parameters:
    ///    - item: `AccessibilityItem` to invalidate
    ///    - accessibilityItemKind: Type of `AccessibilityItem` with provided index
    ///    - accessibilityDelegate: Delegate for invalidation
    public init(item: AccessibilityItem?,
                accessibilityItemKind: AccessibilityItemKind,
                accessibilityDelegate: AccessibilityItemDelegate?) {
        self.item = item
        self.accessibilityItemKind = accessibilityItemKind
        self.accessibilityDelegate = accessibilityDelegate
    }

    public func invalidateParameters() {
        guard let item else { return }
        accessibilityDelegate?.didInvalidateAccessibility(for: item, of: accessibilityItemKind)
    }
}

struct BasicAccessibilityItemInvalidator: AccessibilityItemInvalidator {
    weak var item: AccessibilityItem?

    public func invalidateParameters() {
        guard let item else { return }
        item.modifySelf()

    }
}

/// Protocol for invalidation mechanism
public protocol AccessibilityInvalidatable: AccessibilityItem {
    /// Stored invalidator that can be used for accessibility parameters invalidation.
    /// Fully managed by accessibility plugins. This value is `nil` if item isn't displaying
    var accessibilityInvalidator: AccessibilityItemInvalidator? { get set }

    /// Sets invalidation object to `accessibilityInvalidator` property
    ///  - Parameters:
    ///     - invalidator: Implementation of invalidator
    func setInvalidator(invalidator: AccessibilityItemInvalidator)

    /// Removes invalidation object from `accessibilityInvalidator` property
    /// Also removes all observations added
    func removeInvalidator()
}

public extension AccessibilityInvalidatable {

    // MARK: - Defaults

    func setInvalidator(invalidator: AccessibilityItemInvalidator) {
        accessibilityInvalidator = invalidator
    }

    func removeInvalidator() {
        accessibilityInvalidator = nil
    }

    // MARK: - Shortcuts

    /// Setting invalidator which will call ``AccessibilityItem/modifySelf`` method
    func setBasicInvalidator() {
        setInvalidator(invalidator: BasicAccessibilityItemInvalidator(item: self))
    }
}

public typealias AccessibilityInvalidatorCreationBlock = (AccessibilityItem, AccessibilityItemKind, AccessibilityItemDelegate) -> AccessibilityItemInvalidator

/// Invalidation delegate for `CollectionDelegate` or `TableDelegate`
public protocol AccessibilityItemDelegate: AnyObject {
    func didInvalidateAccessibility(for item: AccessibilityItem, of kind: AccessibilityItemKind)
}
