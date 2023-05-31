//
//  AccessibilityItem+Invalidation.swift
//  ReactiveDataDisplayManager
//
//  Created by korshunov on 31.05.2023.
//

import Foundation

public enum AccessibilityItemKind {
    case header(Int), cell(IndexPath), footer(Int)
}

public struct AccessibilityItemInvalidator {
    let accessibilityItemKind: AccessibilityItemKind
    weak var item: AccessibilityItem?
    weak var accessibilityDelegate: AccessibilityItemDelegate?

    public func invalidateAccessibility() {
        guard let item else { return }
        accessibilityDelegate?.didInvalidateAccessibility(for: item, of: accessibilityItemKind)
    }
}

public protocol AccessibilityInvalidatable: AccessibilityItem {
    var accessibilityInvalidator: AccessibilityItemInvalidator? { get set }
}

extension AccessibilityInvalidatable {
    func setInvalidator(kind: AccessibilityItemKind, delegate: AccessibilityItemDelegate) {
        accessibilityInvalidator = AccessibilityItemInvalidator(accessibilityItemKind: kind, item: self, accessibilityDelegate: delegate)
    }

    func removeInvalidator() {
        accessibilityInvalidator = nil
    }
}

public protocol AccessibilityItemDelegate: AnyObject {
    func didInvalidateAccessibility(for item: AccessibilityItem, of kind: AccessibilityItemKind)
}
