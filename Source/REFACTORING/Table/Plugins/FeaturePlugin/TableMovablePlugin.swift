//
//  TableMovablePlugin.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 02.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

/// Plugin to move cells
///
/// Allow moving cells builded with `MovableGenerator` generators
open class TableMovablePlugin: TableFeaturePlugin {

    public typealias GeneratorType = MovableGenerator

}

// MARK: - TableMovableDelegate

extension TableMovablePlugin: TableMovableDelegate {
    
    open func canMoveRow(at indexPath: IndexPath, with provider: TableGeneratorsProvider?) -> Bool {
        if let generator = provider?.generators[indexPath.section][indexPath.row] as? GeneratorType {
            return generator.canMove()
        }
        return false
    }

}

// MARK: - TableMovableDataSource

extension TableMovablePlugin: TableMovableDataSource {

    open func moveRow(at sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath, with provider: TableGeneratorsProvider?) {
        let moveToTheSameSection = sourceIndexPath.section == destinationIndexPath.section
        guard
            let manager = provider as? BaseTableManager,
            let view = manager.view,
            let generator = manager.generators[sourceIndexPath.section][sourceIndexPath.row] as? GeneratorType,
            moveToTheSameSection || generator.canMoveInOtherSection()
        else {
            return
        }

        let itemToMove = manager.generators[sourceIndexPath.section][sourceIndexPath.row]

        // find oldSection and remove item from this array
        manager.generators[sourceIndexPath.section].remove(at: sourceIndexPath.row)

        // findNewSection and add items to this array
        manager.generators[destinationIndexPath.section].insert(itemToMove, at: destinationIndexPath.row)

        // need to prevent crash with internal inconsistency of UITableView
        DispatchQueue.main.async {
            view.beginUpdates()
            view.endUpdates()
        }
    }

    open func canFocusRow(at indexPath: IndexPath, with provider: TableGeneratorsProvider?) -> Bool {
        if let generator = provider?.generators[indexPath.section][indexPath.row] as? GeneratorType {
            return generator.canMove()
        }
        return false
    }

}

// MARK: - Public init

public extension TableFeaturePlugin {

    /// Plugin to move cells
    ///
    /// Allow moving cells builded with `MovableGenerator` generators
    static func movable() -> TableMovablePlugin {
        .init()
    }

}
