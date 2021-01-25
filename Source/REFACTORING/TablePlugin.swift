//
//  TablePlugin.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 21.01.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

// Adds support for Selectable item triggering
public class TableSelectablePlugin: PluginAction<TableEvent, BaseTableStateManager> {

    override func process(event: TableEvent, with manager: BaseTableStateManager?) {

        switch event {
        case .didSelect(let indexPath):
            guard let selectable = manager?.generators[indexPath.section][indexPath.row] as? SelectableItem else {
                return
            }
            selectable.didSelectEvent.invoke(with: ())

            if selectable.isNeedDeselect {
                manager?.tableView?.deselectRow(at: indexPath, animated: true)
            }
        default:
            break
        }
    }

}

public class TableFoldablePlugin: PluginAction<TableEvent, BaseTableStateManager> {

    override func process(event: TableEvent, with manager: BaseTableStateManager?) {

        switch event {
        case .didSelect(let indexPath):
            guard let generator = manager?.generators[indexPath.section][indexPath.row],
                let foldable = generator as? FoldableItem else {
                return
            }
            if foldable.isExpanded {
                foldable.childGenerators.forEach { manager?.remove($0, with: .none) }
            } else {
                manager?.addCellGenerators(foldable.childGenerators,
                                           after: generator)
            }

            foldable.isExpanded = !foldable.isExpanded
            foldable.didFoldEvent.invoke(with: (foldable.isExpanded))

            manager?.update(generators: foldable.childGenerators)
        default:
            break
        }
    }

}

public class TableDisplayablePlugin: PluginAction<TableEvent, BaseTableStateManager> {

    private func getDisplayableFlowCell(from manager: BaseTableStateManager?, at indexPath: IndexPath) -> DisplayableFlow? {
        manager?.generators[safe: indexPath.section]?[safe: indexPath.row] as? DisplayableFlow
    }

    private func getDisplayableFlowHeader(from manager: BaseTableStateManager?, at section: Int) -> DisplayableFlow? {
        manager?.sections[safe: section] as? DisplayableFlow
    }

    override func process(event: TableEvent, with manager: BaseTableStateManager?) {
        switch event {
        case .willDisplayCell(let indexPath):
            let displayable = getDisplayableFlowCell(from: manager, at: indexPath)
            displayable?.willDisplayEvent.invoke(with: ())
        case .didEndDisplayCell(let indexPath):
            let displayable = getDisplayableFlowCell(from: manager, at: indexPath)
            displayable?.didEndDisplayEvent.invoke(with: ())
        case .willDisplayHeader(let section):
            let displayable = getDisplayableFlowHeader(from: manager, at: section)
            displayable?.willDisplayEvent.invoke(with: ())
        case .didEndDisplayHeader(let section):
            let displayable = getDisplayableFlowHeader(from: manager, at: section)
            displayable?.didEndDisplayEvent.invoke(with: ())
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

    override func process(event: TableEvent, with manager: BaseTableStateManager?) {

        switch event {
        case .willDisplayCell(let indexPath):
            guard let generators = manager?.generators else {
                return
            }
            let lastSectionIndex = generators.count - 1
            let lastCellInLastSectionIndex = generators[lastSectionIndex].count - 1

            let lastCellIndexPath = IndexPath(row: lastCellInLastSectionIndex, section: lastSectionIndex)
            if indexPath == lastCellIndexPath {
                action()
            }
        default:
            break
        }
    }

}
