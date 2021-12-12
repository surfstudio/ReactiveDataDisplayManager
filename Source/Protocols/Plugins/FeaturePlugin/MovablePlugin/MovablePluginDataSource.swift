//
//  MovablePluginDataSource.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 15.04.2021.
//

import Foundation
import UIKit

/// Data source based on `MovableDataSource` protocol.
open class MovablePluginDataSource<Provider: GeneratorsProvider> {

    // MARK: - Typealias

    public typealias GeneratorType = MovableItem

}

// MARK: - MovableDataSource

extension MovablePluginDataSource: MovableDataSource {

    /// Moves the item at a specific location in the view to a different location
    /// - parameters:
    ///     - at: index path locating the item to be moved
    ///     - to: index path locating the item that is the destination of the move
    ///     - with: current provider with generators
    ///     - and: view object requesting this action.
    ///     - animator: an animator object for animating movement
    open func moveRow<Collection: UIView>(at sourceIndexPath: IndexPath,
                                          to destinationIndexPath: IndexPath,
                                          with provider: Provider?,
                                          and view: Collection,
                                          animator: Animator<Collection>?) {
        let moveToTheSameSection = sourceIndexPath.section == destinationIndexPath.section
        guard
            let provider = provider,
            let generator = provider.sections[sourceIndexPath.section].generators[sourceIndexPath.row] as? GeneratorType,
            moveToTheSameSection || generator.canMoveInOtherSection()
        else { return }

        let itemToMove = provider.sections[sourceIndexPath.section].generators[sourceIndexPath.row]

        // find oldSection and remove item from this array
        provider.sections[sourceIndexPath.section].generators.remove(at: sourceIndexPath.row)

        // findNewSection and add items to this array
        provider.sections[destinationIndexPath.section].generators.insert(itemToMove, at: destinationIndexPath.row)

        animator?.perform(in: view, animated: true, operation: { })
    }

    /// Asks whether a given item can be moved to another location
    /// - parameters:
    ///     - at: index path of a given item
    ///     - with: current provider with generators
    open func canMoveRow(at indexPath: IndexPath, with provider: Provider?) -> Bool {
        if let generator = provider?.sections[indexPath.section].generators[indexPath.row] as? GeneratorType {
            return generator.canMove()
        }
        return false
    }

}
