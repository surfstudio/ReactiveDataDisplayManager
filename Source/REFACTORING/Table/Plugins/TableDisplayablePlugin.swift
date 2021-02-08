//
//  TableDisplayablePlugin.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 28.01.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

public class TableDisplayablePlugin: BaseTablePlugin<TableEvent> {

    private func getDisplayableFlowCell(from manager: BaseTableStateManager?, at indexPath: IndexPath) -> DisplayableFlow? {
        manager?.generators[safe: indexPath.section]?[safe: indexPath.row] as? DisplayableFlow
    }

    private func getDisplayableFlowHeader(from manager: BaseTableStateManager?, at section: Int) -> DisplayableFlow? {
        manager?.sections[safe: section] as? DisplayableFlow
    }

    public override func process(event: TableEvent, with manager: BaseTableStateManager?) {
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
