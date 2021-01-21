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
                manager.adapter?.tableView.deselectRow(at: indexPath, animated: true)
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

public class TableLastCellIsVisiblePlugin: PluginAction<TableEvent, BaseTableStateManager> {

    private let action: () -> Void

    public init(action: @escaping () -> Void) {
        self.action = action
    }

    override func process(event: TableEvent, with manager: BaseTableStateManager) {

        switch event {
        case .willDisplay(let indexPath):
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
