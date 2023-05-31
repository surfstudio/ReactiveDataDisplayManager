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
        case let .willDisplayCell(indexPath, cell), let .invalidatedCellAccessibility(indexPath, cell):
            guard let accessibilityItem = cell as? AccessibilityItem else {
                return
            }
            if let generator = manager?.generators[indexPath.section][indexPath.row] as? AccessibilityStrategyProvider {
                accessibilityItem.modifierType.modify(item: accessibilityItem, generator: generator)
            } else {
                accessibilityItem.modifierType.modify(item: accessibilityItem)
            }

        case let .willDisplayHeader(section, view), let .invalidatedHeaderAccessibility(section, view):
            guard let accessibilityItem = view as? AccessibilityItem else {
                return
            }
            if let headerGenerator = manager?.sections[section] as? AccessibilityStrategyProvider {
                accessibilityItem.modifierType.modify(item: accessibilityItem, generator: headerGenerator)
            } else {
                accessibilityItem.modifierType.modify(item: accessibilityItem)
            }

        case let .willDisplayFooter(_, view), let .invalidatedFooterAccessibility(_, view):
            guard let accessibilityItem = view as? AccessibilityItem else {
                return
            }
            // AccessibilityStrategyProvider for a footer generator is not supported yet
            // TODO: SPT-1468
            accessibilityItem.modifierType.modify(item: accessibilityItem)

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
