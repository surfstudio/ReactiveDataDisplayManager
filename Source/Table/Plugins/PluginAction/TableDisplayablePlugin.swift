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
        case .willDisplayCell(let indexPath):
            let displayable = getDisplayableFlowCell(from: manager, at: indexPath)
            displayable?.willDisplayEvent.invoke()
        case .didEndDisplayCell(let indexPath):
            let displayable = getDisplayableFlowCell(from: manager, at: indexPath)
            displayable?.didEndDisplayEvent.invoke()
        case .willDisplayHeader(let section):
            let displayable = getDisplayableFlowHeader(from: manager, at: section)
            displayable?.willDisplayEvent.invoke()
        case .didEndDisplayHeader(let section):
            let displayable = getDisplayableFlowHeader(from: manager, at: section)
            displayable?.didEndDisplayEvent.invoke()
        default:
            break
        }
    }

}

// MARK: - Private Methods

private extension TableDisplayablePlugin {

    func getDisplayableFlowCell(from manager: BaseTableManager?, at indexPath: IndexPath) -> DisplayableItem? {
        manager?.sections[safe: indexPath.section]?.generators[safe: indexPath.row] as? DisplayableItem
    }

    func getDisplayableFlowHeader(from manager: BaseTableManager?, at section: Int) -> DisplayableItem? {
        manager?.sections[safe: section]?.header as? DisplayableItem
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
