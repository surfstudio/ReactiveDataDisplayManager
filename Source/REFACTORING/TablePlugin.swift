//
//  TablePlugin.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 21.01.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

// Adds support for Selectable item triggering
public class TableSelectablePlugin: PluginAction<TableEvent, BaseTableStateManager> {

    override func process(event: TableEvent, with manager: BaseTableStateManager) {

        switch event {
        case .didSelect(let indexPath):
            guard let selectable = manager.generators[indexPath.section][indexPath.row] as? SelectableItem else {
                return
            }
            selectable.didSelectEvent.invoke(with: ())

            if selectable.isNeedDeselect {
                manager.tableView?.deselectRow(at: indexPath, animated: true)
            }
        default:
            break
        }
    }

}

public class TableFoldablePlugin: PluginAction<TableEvent, BaseTableStateManager> {

    override func process(event: TableEvent, with manager: BaseTableStateManager) {

        switch event {
        case .didSelect(let indexPath):
            guard let foldable = manager.generators[indexPath.section][indexPath.row] as? FoldableItem else {
                return
            }
            if foldable.isExpanded {
                foldable.childGenerators.forEach { manager.remove($0, with: .none) }
            } else {
                manager.addCellGenerators(foldable.childGenerators,
                                          after: manager.generators[indexPath.section][indexPath.row])
            }

            foldable.isExpanded = !foldable.isExpanded
            foldable.didFoldEvent.invoke(with: (foldable.isExpanded))

            manager.update(generators: foldable.childGenerators)
        default:
            break
        }
    }

}

public class TableDisplayablePlugin: PluginAction<TableEvent, BaseTableStateManager> {

    override func process(event: TableEvent, with manager: BaseTableStateManager) {
        switch event {
        case .willDisplayCell(let indexPath):
            guard let displayable = manager.generators[safe: indexPath.section]?[safe: indexPath.row] as? DisplayableFlow else {
                return
            }
            displayable.willDisplayEvent.invoke(with: ())
        case .didEndDisplayCell(let indexPath):
            guard let displayable = manager.generators[safe: indexPath.section]?[safe: indexPath.row] as? DisplayableFlow else {
                return
            }
            displayable.didEndDisplayEvent.invoke(with: ())
        case .willDisplayHeader(let section):
            guard let displayable = manager.sections[safe: section] as? DisplayableFlow else {
                return
            }
            displayable.willDisplayEvent.invoke(with: ())
        case .didEndDisplayHeader(let section):
            guard let displayable = manager.sections[safe: section] as? DisplayableFlow else {
                return
            }
            displayable.didEndDisplayEvent.invoke(with: ())
        default:
            break
        }
    }

}

public class TableMovablePlugin: PluginAction<TableEvent, BaseTableStateManager> {

    override func process(event: TableEvent, with manager: BaseTableStateManager) {

        switch event {
        case .move(let from, let to):
            let moveToTheSameSection = from.section == to.section
            guard
                let generator = manager.generators[from.section][from.row] as? MovableGenerator,
                moveToTheSameSection || generator.canMoveInOtherSection()
            else {
                return
            }

            let itemToMove = manager.generators[from.section][from.row]

            // find oldSection and remove item from this array
            manager.generators[from.section].remove(at: from.row)

            // findNewSection and add items to this array
            manager.generators[to.section].insert(itemToMove, at: to.row)

            // need to prevent crash with internal inconsistency of UITableView
            DispatchQueue.main.async {
                manager.tableView?.beginUpdates()
                manager.tableView?.endUpdates()
            }
        default:
            break
        }
    }

//    override func processBool(event: TableEvent, with manager: BaseTableStateManager) -> Bool? {
//
//        switch event {
//        case .canMove(let indexPath), .canFocus(let indexPath):
//            if let generator = manager.generators[indexPath.section][indexPath.row] as? MovableGenerator {
//                return generator.canMove()
//            }
//            return nil
//        default:
//            return nil
//        }
//    }

}

public class TableLastCellIsVisiblePlugin: PluginAction<TableEvent, BaseTableStateManager> {

    private let action: () -> Void

    public init(action: @escaping () -> Void) {
        self.action = action
    }

    override func process(event: TableEvent, with manager: BaseTableStateManager) {

        switch event {
        case .willDisplayCell(let indexPath):
            let lastSectionIndex = manager.generators.count - 1
            let lastCellInLastSectionIndex = manager.generators[lastSectionIndex].count - 1

            let lastCellIndexPath = IndexPath(row: lastCellInLastSectionIndex, section: lastSectionIndex)
            if indexPath == lastCellIndexPath {
                action()
            }
        default:
            break
        }
    }

}
