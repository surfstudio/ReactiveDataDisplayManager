//
//  Movable.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 15.04.2021.
//

import Foundation
import UIKit

public protocol Movable {
    associatedtype DelegateType: MovableDelegate
    associatedtype DataSourceType: MovableDataSource

    var delegate: DelegateType { get set }
    var dataSource: DataSourceType { get set }
}

public protocol MovableDataSource {
    associatedtype Provider: GeneratorsProvider

    /// Asks whether a given item can be moved to another location
    /// - parameters:
    ///     - at: index path of a given item
    ///     - with: current provider with generators
    func canMoveRow(at indexPath: IndexPath, with provider: Provider?) -> Bool

    /// Moves the item at a specific location in the view to a different location
    /// - parameters:
    ///     - at: index path locating the item to be moved
    ///     - to: index path locating the item that is the destination of the move
    ///     - with: current provider with generators
    ///     - and: view object requesting this action.
    ///     - animator: an animator object for animating movement
    func moveRow<Collection: UIView>(at sourceIndexPath: IndexPath,
                                     to destinationIndexPath: IndexPath,
                                     with provider: Provider?,
                                     and view: Collection,
                                     animator: Animator<Collection>?)
}

public protocol MovableDelegate {
    associatedtype Provider: GeneratorsProvider

    /// Asks whether the item at the specified index path can be focused
    /// - parameters:
    ///     - at: index path of the focused item
    ///     - with: current provider with generators
    func canFocusRow(at indexPath: IndexPath, with provider: Provider?) -> Bool
}
