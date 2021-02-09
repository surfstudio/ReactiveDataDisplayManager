//
//  MovableTableDelegate.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 02.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

open class MovableTableDataSource: BaseTableDataSource {

    open override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if let generator = provider?.generators[indexPath.section][indexPath.row] as? MovableGenerator {
            return generator.canMove()
        }
        return super.tableView(tableView, canMoveRowAt: indexPath)
    }

    open override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        super.tableView(tableView, moveRowAt: sourceIndexPath, to: destinationIndexPath)

        let moveToTheSameSection = sourceIndexPath.section == destinationIndexPath.section
        guard
            let stateManager = provider,
            let generator = stateManager.generators[sourceIndexPath.section][sourceIndexPath.row] as? MovableGenerator,
            moveToTheSameSection || generator.canMoveInOtherSection()
        else {
            return
        }

        let itemToMove = stateManager.generators[sourceIndexPath.section][sourceIndexPath.row]

        // find oldSection and remove item from this array
        stateManager.generators[sourceIndexPath.section].remove(at: sourceIndexPath.row)

        // findNewSection and add items to this array
        stateManager.generators[destinationIndexPath.section].insert(itemToMove, at: destinationIndexPath.row)

        // need to prevent crash with internal inconsistency of UITableView
        DispatchQueue.main.async {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }

}
