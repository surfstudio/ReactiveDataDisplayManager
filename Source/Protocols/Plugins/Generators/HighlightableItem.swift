//
//  HighlightableItem.swift
//  Pods
//
//  Created by porohov on 23.06.2022.
//

import Foundation

/// Protocol for `Cell` to manage selectable style
public protocol HighlightableItem {

    /// Invokes when user taps on the item.
    func applyUnhighlightedStyle()

    /// Called when the user takes their finger off the element.
    func applyHighlightedStyle()

    /// Invokes when user taps on the item. Remains selected if `SelectableItem.isNeedDeselect == true`
    func applySelectedStyle()

    /// Called when the user clicks the selected cell again. Depends on collection `allowsMultipleSelection`
    func applyDeselectedStyle()
}

// MARK: - Default

public extension HighlightableItem {

    func applyUnhighlightedStyle() { }
    func applyHighlightedStyle() { }
    func applySelectedStyle() { }
    func applyDeselectedStyle() { }
}
