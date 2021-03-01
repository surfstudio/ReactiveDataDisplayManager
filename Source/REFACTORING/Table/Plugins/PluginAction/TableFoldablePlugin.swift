//
//  TableFoldablePlugin.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 28.01.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

public class TableFoldablePlugin: BaseTablePlugin<TableEvent> {

    // MARK: - BaseTablePlugin

    public override func process(event: TableEvent, with manager: BaseTableManager?) {
        switch event {
        case .didSelect(let indexPath):
            guard
                let generator = manager?.generators[indexPath.section][indexPath.row],
                let foldable = generator as? RDDMFoldableItem
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
                           with manager: BaseTableManager?) {
        if let manager = manager as? ManualTableManager {
            manager.insert(after: generator, new: childGenerators, with: .fade)
        } else if let manager = manager as? GravityTableManager {
            manager.addCellGenerators(childGenerators, after: generator)
        }
    }

    func updateIfNeeded(_ childGenerators: [TableCellGenerator], with manager: BaseTableManager?) {
        guard let manager = manager as? GravityTableManager else { return }
        manager.update(generators: childGenerators)
    }

}
