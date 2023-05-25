//
//  TableLastCellIsVisiblePlugin.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 28.01.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

/// Plugin to add reaction on `willDisplayCell` of last cell
public class TableLastCellIsVisiblePlugin: BaseTablePlugin<TableEvent> {

    // MARK: - Private Properties

    private let action: () -> Void

    // MARK: - Initialization

    /// - parameter action: closure with reaction to visibility of last cell
    init(action: @escaping () -> Void) {
        self.action = action
    }

    // MARK: - BaseTablePlugin

    public override func process(event: TableEvent, with manager: BaseTableManager?) {

        switch event {
        case .willDisplayCell(let indexPath, _):
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

// MARK: - Public init

public extension BaseTablePlugin {

    /// Plugin to add reaction on `willDisplayCell` of last cell
    ///
    /// - parameter action: closure with reaction to visibility of last cell
    static func lastCellIsVisible(action: @escaping () -> Void) -> TableLastCellIsVisiblePlugin {
        .init(action: action)
    }

}
