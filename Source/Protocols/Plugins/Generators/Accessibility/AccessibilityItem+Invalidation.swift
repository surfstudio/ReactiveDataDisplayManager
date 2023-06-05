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

struct CommonAccessibilityItemInvalidator: AccessibilityItemInvalidator {
    let accessibilityItemKind: AccessibilityItemKind
    weak var item: AccessibilityItem?
    weak var accessibilityDelegate: AccessibilityItemDelegate?

    public func invalidateParameters() {
        guard let item else { return }
        accessibilityDelegate?.didInvalidateAccessibility(for: item, of: accessibilityItemKind)
    }
}

/// Protocol for invalidation mechanism
public protocol AccessibilityInvalidatable: AccessibilityItem {
    /// Stored invalidator that can be used for accessibility parameters invalidation.
    /// Fully managed by accessibility plugins. This value is `nil` if item isn't displaying
    var accessibilityInvalidator: AccessibilityItemInvalidator? { get set }
}

extension AccessibilityInvalidatable {
    func setInvalidator(kind: AccessibilityItemKind, delegate: AccessibilityItemDelegate?) {
        accessibilityInvalidator = CommonAccessibilityItemInvalidator(accessibilityItemKind: kind, item: self, accessibilityDelegate: delegate)
    }

    func removeInvalidator() {
        accessibilityInvalidator = nil
    }
}

/// Invalidation delegate for `CollectionDelegate` or `TableDelegate`
public protocol AccessibilityItemDelegate: AnyObject {
    func didInvalidateAccessibility(for item: AccessibilityItem, of kind: AccessibilityItemKind)
}
