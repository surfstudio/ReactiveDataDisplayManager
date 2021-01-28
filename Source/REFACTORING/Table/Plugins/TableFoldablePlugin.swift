//
//  TableFoldablePlugin.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 28.01.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

public class TableFoldablePlugin: PluginAction<TableEvent, BaseTableStateManager> {

    override func process(event: TableEvent, with manager: BaseTableStateManager?) {

        switch event {
        case .didSelect(let indexPath):
            guard let generator = manager?.generators[indexPath.section][indexPath.row],
                let foldable = generator as? FoldableItem else {
                return
            }
            if foldable.isExpanded {
                foldable.childGenerators.forEach { manager?.remove($0,
                                                                   with: .none,
                                                                   needScrollAt: nil,
                                                                   needRemoveEmptySection: false)
                }
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
