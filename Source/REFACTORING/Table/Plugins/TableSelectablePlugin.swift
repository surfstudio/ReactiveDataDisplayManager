//
//  TableSelectablePlugin.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 28.01.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

// Adds support for Selectable item triggering
public class TableSelectablePlugin: BaseTablePlugin<TableEvent> {

    public override func process(event: TableEvent, with manager: BaseTableStateManager?) {

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
