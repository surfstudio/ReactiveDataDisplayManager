//
//  GravityFoldingTableDataDisplayManager.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Dryakhlykh on 11.11.2019.
//  Copyright © 2019 Александр Кравченков. All rights reserved.
//

open class GravityFoldingTableDataDisplayManager: GravityTableDataDisplayManager {
    override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectable = cellGenerators[indexPath.section][indexPath.row] as? SelectableItem {
            selectable.didSelectEvent.invoke(with: ())

            if selectable.isNeedDeselect {
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }

        if let foldable = cellGenerators[indexPath.section][indexPath.row] as? GravityFoldableItem {
            if foldable.isExpanded {
                foldable.childGenerators.forEach { self.remove($0, with: .none) }
            } else {
                addCellGenerators(foldable.childGenerators,
                                  after: cellGenerators[indexPath.section][indexPath.row])
            }

            foldable.isExpanded = !foldable.isExpanded
            foldable.didFoldEvent.invoke(with: (foldable.isExpanded))

            update(generators: foldable.childGenerators)
        }
    }
}
