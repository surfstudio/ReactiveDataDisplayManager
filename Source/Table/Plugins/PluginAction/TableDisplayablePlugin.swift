//
//  TableDisplayablePlugin.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 28.01.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

/// Plugin to support `DisplayableItem` generators
///
/// Allow track`willDisplay` or `didEndDisplay` events inside generator
public class TableDisplayablePlugin: BaseTablePlugin<TableEvent> {

    // MARK: - BaseTablePlugin

    public override func process(event: TableEvent, with manager: BaseTableManager?) {
        switch event {
        case .willDisplayCell(let indexPath, _):
            let displayable = getDisplayableFlowCell(from: manager, at: indexPath)
            displayable?.willDisplayEvent.invoke(with: ())
        case .didEndDisplayCell(let indexPath, _):
            let displayable = getDisplayableFlowCell(from: manager, at: indexPath)
            displayable?.didEndDisplayEvent.invoke(with: ())
        case .willDisplayHeader(let section, _):
            let displayable = getDisplayableFlowHeader(from: manager, at: section)
            displayable?.willDisplayEvent.invoke(with: ())
        case .didEndDisplayHeader(let section, _):
            let displayable = getDisplayableFlowHeader(from: manager, at: section)
            displayable?.didEndDisplayEvent.invoke(with: ())
        default:
            break
        }
    }

}

// MARK: - Private Methods

private extension TableDisplayablePlugin {

    func getDisplayableFlowCell(from manager: BaseTableManager?, at indexPath: IndexPath) -> DisplayableItem? {
        manager?.generators[safe: indexPath.section]?[safe: indexPath.row] as? DisplayableItem
    }

    func getDisplayableFlowHeader(from manager: BaseTableManager?, at section: Int) -> DisplayableItem? {
        manager?.sections[safe: section] as? DisplayableItem
    }

}

// MARK: - Public init

public extension BaseTablePlugin {

    /// Plugin to support `DisplayableItem` generators
    ///
    /// Alllow track`willDisplay` or `didEndDisplay` events inside generator
    static func displayable() -> TableDisplayablePlugin {
        .init()
    }

}
