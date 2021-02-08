//
//  MovableTableDelegate.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 22.01.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

open class MovableTableDelegate: BaseTableDelegate {

    open override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if let generator = manager?.generators[indexPath.section][indexPath.row] as? MovableGenerator {
            return generator.canMove()
        }
        return super.tableView(tableView, canMoveRowAt: indexPath)
    }

    open override func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        if let generator = manager?.generators[indexPath.section][indexPath.row] as? MovableGenerator {
            return generator.canMove()
        }
        return super.tableView(tableView, canFocusRowAt: indexPath)
    }

    open override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        super.tableView(tableView, moveRowAt: sourceIndexPath, to: destinationIndexPath)

        let moveToTheSameSection = sourceIndexPath.section == destinationIndexPath.section
        guard
            let manager = manager,
            let generator = manager.generators[sourceIndexPath.section][sourceIndexPath.row] as? MovableGenerator,
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
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }

}
