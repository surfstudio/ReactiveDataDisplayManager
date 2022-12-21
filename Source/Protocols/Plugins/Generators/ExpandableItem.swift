//
//  ExpandableItem.swift
//  Pods
//
//  Created by porohov on 30.12.2021.
//

import UIKit

/// Protocol for `TableCellGenerator` for Height Change Control
public protocol ExpandableItem: AnyObject {

    /// Called when the height of the cell changes
    var onHeightChanged: BaseEvent<CGFloat?> { get }
    var animatedExpandable: Bool { get set }
}
