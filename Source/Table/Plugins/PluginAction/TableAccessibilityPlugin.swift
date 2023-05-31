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
        case let .willDisplayCell(indexPath, cell):
            processTableCell(indexPath, cell, with: manager)
            (cell as? AccessibilityInvalidatable)?.setInvalidator(kind: .cell(indexPath), delegate: manager?.delegate)

        case let .invalidatedCellAccessibility(indexPath, cell):
            processTableCell(indexPath, cell, with: manager)

        case let .willDisplayHeader(section, view):
            processTableHeader(section, view, with: manager)
            (view as? AccessibilityInvalidatable)?.setInvalidator(kind: .header(section), delegate: manager?.delegate)

        case let .invalidatedHeaderAccessibility(section, view):
            processTableHeader(section, view, with: manager)

        case let .willDisplayFooter(section, view):
            processTableFooter(section, view, with: manager)
            (view as? AccessibilityInvalidatable)?.setInvalidator(kind: .footer(section), delegate: manager?.delegate)

        case let .invalidatedFooterAccessibility(section, view):
            processTableFooter(section, view, with: manager)

        case let .didEndDisplayFooter(_, view), let .didEndDisplayHeader(_, view), let .didEndDisplayCell(_, view as UIView):
            (view as? AccessibilityInvalidatable)?.removeInvalidator()

        default:
            break
        }
    }

    private func processTableCell(_ indexPath: IndexPath, _ cell: UITableViewCell, with manager: BaseTableManager?) {
        guard let accessibilityItem = cell as? AccessibilityItem else {
            return
        }
        if let generator = manager?.generators[indexPath.section][indexPath.row] as? AccessibilityStrategyProvider {
            accessibilityItem.modifierType.modify(item: accessibilityItem, generator: generator)
        } else {
            accessibilityItem.modifierType.modify(item: accessibilityItem)
        }
    }

    private func processTableHeader(_ section: Int, _ view: UIView, with manager: BaseTableManager?) {
        guard let accessibilityItem = view as? AccessibilityItem else {
            return
        }
        if let header = manager?.sections[section] as? AccessibilityStrategyProvider {
            accessibilityItem.modifierType.modify(item: accessibilityItem, generator: header)
        } else {
            accessibilityItem.modifierType.modify(item: accessibilityItem)
        }
    }

    private func processTableFooter(_ section: Int, _ view: UIView, with manager: BaseTableManager?) {
        guard let accessibilityItem = view as? AccessibilityItem else {
            return
        }
        // AccessibilityStrategyProvider for a footer generator is not supported yet
        // TODO: SPT-1468
        accessibilityItem.modifierType.modify(item: accessibilityItem)
    }

}

extension BaseTablePlugin {
    static func accessibility() -> BaseTablePlugin<TableEvent> {
        TableAccessibilityPlugin()
    }
}
