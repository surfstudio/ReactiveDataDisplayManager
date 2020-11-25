////
////  MovableTableDelegate.swift
////  ReactiveDataDisplayManager
////
////  Created by Aleksandr Smirnov on 23.11.2020.
////  Copyright © 2020 Александр Кравченков. All rights reserved.
////
//
//import Foundation
//
//open class MovableTableDelegate: BaseTableDelegate {
//
//    override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let selectable = adapter?.stateManager.generators[indexPath.section][indexPath.row] as? SelectableItem {
//            selectable.didSelectEvent.invoke(with: ())
//
//            if selectable.isNeedDeselect {
//                tableView.deselectRow(at: indexPath, animated: true)
//            }
//        }
//
//        if let foldable = adapter?.stateManager.generators[indexPath.section][indexPath.row] as? FoldableItem {
//            if foldable.isExpanded {
//                foldable.childGenerators.forEach { self.adapter?.remove($0, with: .none) }
//            } else if let adapter = self.adapter {
//                adapter.addCellGenerators(foldable.childGenerators,
//                                          after: adapter.stateManager.generators[indexPath.section][indexPath.row])
//            }
//
//            foldable.isExpanded = !foldable.isExpanded
//            foldable.didFoldEvent.invoke(with: (foldable.isExpanded))
//
//            self.adapter?.update(generators: foldable.childGenerators)
//        }
//    }
//
//}
