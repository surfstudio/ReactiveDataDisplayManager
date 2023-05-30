//
//  TableAccessibilityPlugin.swift
//  ReactiveDataDisplayManager
//
//  Created by korshunov on 25.05.2023.
//

import Foundation

import UIKit

final class TableAccessibilityPlugin: BaseTablePlugin<TableEvent> {

    override func process(event: TableEvent, with manager: BaseTableManager?) {
        switch event {
        case .willDisplayCell(let indexPath, let cell):
            guard let accessibilityItem = cell as? AccessibilityItem else {
                return
            }
            if let generator = manager?.generators[indexPath.section][indexPath.row] as? AccessibilityStrategyProvider {
                accessibilityItem.modifierType.modify(view: cell.contentView, with: accessibilityItem, generator: generator)
            } else {
                accessibilityItem.modifierType.modify(view: cell.contentView, with: accessibilityItem)
            }

        case .willDisplayHeader(let section, let view):
            guard let accessibilityItem = view as? AccessibilityItem else {
                return
            }
            if let headerGenerator = manager?.sections[section] as? AccessibilityStrategyProvider {
                accessibilityItem.modifierType.modify(view: view, with: accessibilityItem, generator: headerGenerator)
            } else {
                accessibilityItem.modifierType.modify(view: view, with: accessibilityItem)
            }

        case .willDisplayFooter(_, let view):
            guard let accessibilityItem = view as? AccessibilityItem else {
                return
            }
            // AccessibilityStrategyProvider for a footer generator is not supported yet
            // TODO: SPT-1468
            accessibilityItem.modifierType.modify(view: view, with: accessibilityItem)

        default:
            break
        }
    }

}

extension BaseTablePlugin {
    static func accessibility() -> BaseTablePlugin<TableEvent> {
        TableAccessibilityPlugin()
    }
}
