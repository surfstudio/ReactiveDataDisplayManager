//
//  XCUITestsAccessibilityModifier.swift
//  ReactiveDataDisplayManager
//
//  Created by korshunov on 04.07.2023.
//

import UIKit

#if DEBUG
/// Special modifier for UI tests, which adds `.button` trait for `UITableViewCell` and `UICollectionViewCell` to make them conform to cell `XCUIElement` type.
/// Also adds trait `.staticText` for headers and footers to make them accessible by identifier
public enum XCUITestsAccessibilityModifier: AccessibilityModifier {

    public static func modify(item: AccessibilityItem) {
        AccessibilityItemModifier.modify(item: item)
        if item is UITableViewCell || item is UICollectionViewCell {
            item.accessibilityTraits.insert(.button)
        } else {
            item.accessibilityTraits.insert(.staticText)
        }
    }

    public static func modify(item: AccessibilityItem, generator: AccessibilityStrategyProvider) {
        AccessibilityItemModifier.modify(item: item, generator: generator)
        if item is UITableViewCell || item is UICollectionViewCell {
            item.accessibilityTraits.insert(.button)
        } else {
            item.accessibilityTraits.insert(.staticText)
        }
    }

}
#endif
