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

    // MARK: - Properties

    var cellDidChangePosition: ((ResultChangeCellPosition) -> Void)?

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
    public func moveRow<Collection: UIView>(at sourceIndexPath: IndexPath,
                                            to destinationIndexPath: IndexPath,
                                            with provider: Provider?,
                                            and view: Collection,
                                            animator: Animator<Collection>?) {
        let moveToTheSameSection = sourceIndexPath.section == destinationIndexPath.section
        guard
            let provider = provider,
            let generator = provider.generators[sourceIndexPath.section][sourceIndexPath.row] as? GeneratorType,
            moveToTheSameSection || generator.canMoveInOtherSection()
        else { return }

        let itemToMove = provider.generators[sourceIndexPath.section][sourceIndexPath.row]

        // find oldSection and remove item from this array
        provider.generators[sourceIndexPath.section].remove(at: sourceIndexPath.row)

        // findNewSection and add items to this array
        provider.generators[destinationIndexPath.section].insert(itemToMove, at: destinationIndexPath.row)

        animator?.perform(in: view, animated: true, operation: nil)

        cellDidChangePosition?(.init(id: generator.id, oldIndex: sourceIndexPath, newIndex: destinationIndexPath))
    }

    /// Asks whether a given item can be moved to another location
    /// - parameters:
    ///     - at: index path of a given item
    ///     - with: current provider with generators
    public func canMoveRow(at indexPath: IndexPath, with provider: Provider?) -> Bool {
        if let generator = provider?.generators[indexPath.section][indexPath.row] as? GeneratorType {
            return generator.canMove()
        }
        return false
    }

}
