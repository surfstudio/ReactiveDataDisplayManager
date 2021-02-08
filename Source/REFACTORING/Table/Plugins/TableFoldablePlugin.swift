//
//  TableFoldablePlugin.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 28.01.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

public class TableFoldablePlugin: BaseTablePlugin<TableEvent> {

    public override func process(event: TableEvent, with manager: BaseTableStateManager?) {

        switch event {
        case .didSelect(let indexPath):
            guard
                let generator = manager?.generators[indexPath.section][indexPath.row],
                let foldable = generator as? FoldableItem
            else {
                return
            }

            if foldable.isExpanded {
                foldable.childGenerators.forEach { manager?.remove($0,
                                                                   with: .none,
                                                                   needScrollAt: nil,
                                                                   needRemoveEmptySection: false)
                }
            } else {
                addCellGenerators(foldable.childGenerators, after: generator, with: manager)
            }

            foldable.isExpanded = !foldable.isExpanded
            foldable.didFoldEvent.invoke(with: (foldable.isExpanded))

            updateIfNeeded(foldable.childGenerators, with: manager)
        default:
            break
        }
    }

}

// MARK: - Private Methods

private extension TableFoldablePlugin {

    func addCellGenerators(_ childGenerators: [TableCellGenerator],
                           after generator: TableCellGenerator,
                           with manager: BaseTableStateManager?) {
        if let manager = manager as? ManualTableStateManager {
            manager.insert(after: generator, new: childGenerators, with: .fade)
        } else if let manager = manager as? GravityTableStateManager {
            manager.addCellGenerators(childGenerators, after: generator)
        }
    }

    func updateIfNeeded(_ childGenerators: [TableCellGenerator], with manager: BaseTableStateManager?) {
        guard let manager = manager as? GravityTableStateManager else { return }
        manager.update(generators: childGenerators)
    }

}
