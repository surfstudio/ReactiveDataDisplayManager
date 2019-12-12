//
//  FoldingTableDataDisplayManager.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Dryakhlykh on 11.11.2019.
//  Copyright © 2019 Александр Кравченков. All rights reserved.
//

open class FoldingTableDataDisplayManager: BaseTableDataDisplayManager {

    // MARK: - Properties

    public private(set) var foldingCellGenerators: [TableCellGenerator] = []

    // MARK: - BaseTableDataDisplayManager

    override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectable = cellGenerators[indexPath.section][indexPath.row] as? SelectableItem {
            selectable.didSelectEvent.invoke(with: ())

            if selectable.isNeedDeselect {
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }

        if let foldable = cellGenerators[indexPath.section][indexPath.row] as? FoldableItem {
            if foldable.isExpanded {
                foldingCellGenerators.append(contentsOf: foldable.childGenerators)
            } else {
                foldingCellGenerators.removeAll()
            }

            foldable.isExpanded = !foldable.isExpanded
            foldable.didFoldEvent.invoke(with: (foldable.isExpanded))

            UIView.transition(
                with: tableView,
                duration: 0.3,
                options: [.curveEaseInOut, .transitionCrossDissolve],
                animations: {
                    tableView.beginUpdates()
                    tableView.endUpdates()
                }
            )
        }
    }

    override open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if foldingCellGenerators.contains(where: { $0 === cellGenerators[indexPath.section][indexPath.row] }) {
            return 0.0
        } else {
            return cellGenerators[indexPath.section][indexPath.row].cellHeight
        }
    }
}
