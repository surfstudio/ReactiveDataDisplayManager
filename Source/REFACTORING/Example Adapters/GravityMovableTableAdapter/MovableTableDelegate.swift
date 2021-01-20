//
//  MovableTableDelegate.swift
//  ReactiveDataDisplayManager
//
//  Created by Aleksandr Smirnov on 23.11.2020.
//  Copyright © 2020 Александр Кравченков. All rights reserved.
//

import Foundation

protocol MovableAdapter {
    func remove()
}

open class MovableTableDelegate<T: TableStateManager>: BaseTableDelegate<T> where T.CellGeneratorType: TableCellGenerator, T.HeaderGeneratorType: TableHeaderGenerator {

    override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectable = stateManager?.generators[indexPath.section][indexPath.row] as? SelectableItem {
            selectable.didSelectEvent.invoke(with: ())

            if selectable.isNeedDeselect {
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }

        if let foldable = stateManager?.generators[indexPath.section][indexPath.row] as? FoldableItem {
            if foldable.isExpanded {
                foldable.childGenerators.forEach { (item: TableCellGenerator) in
                    self.stateManager?.remove(item, with: .none, needScrollAt: nil, needRemoveEmptySection: false)
                }
            } else if let stateManager = self.stateManager {
                stateManager.addCellGenerators(foldable.childGenerators,
                                          after: stateManager.generators[indexPath.section][indexPath.row])
            }

            foldable.isExpanded = !foldable.isExpanded
            foldable.didFoldEvent.invoke(with: (foldable.isExpanded))

            self.stateManager?.update(generators: foldable.childGenerators)
        }
    }

}
