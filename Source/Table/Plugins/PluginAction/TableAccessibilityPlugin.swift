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
            guard let cell = cell as? AccessibilityItem else { return }

            processTableCell(indexPath, cell, with: manager)
            tryToSetInvalidator(for: cell, of: .cell(indexPath), with: manager)

        case let .invalidatedCellAccessibility(indexPath, cell):
            processTableCell(indexPath, cell, with: manager)

        case let .willDisplayHeader(section, view):
            guard let view = view as? AccessibilityItem else { return }

            processTableHeader(section, view, with: manager)
            tryToSetInvalidator(for: view, of: .header(section), with: manager)

        case let .invalidatedHeaderAccessibility(section, view):
            processTableHeader(section, view, with: manager)

        case let .willDisplayFooter(section, view):
            guard let view = view as? AccessibilityItem else { return }

            processTableFooter(section, view, with: manager)
            tryToSetInvalidator(for: view, of: .footer(section), with: manager)

        case let .invalidatedFooterAccessibility(section, view):
            processTableFooter(section, view, with: manager)

        case let .didEndDisplayFooter(_, view), let .didEndDisplayHeader(_, view), let .didEndDisplayCell(_, view as UIView):
            (view as? AccessibilityInvalidatable)?.removeInvalidator()

        default:
            break
        }
    }

}

private extension TableAccessibilityPlugin {

    func tryToSetInvalidator(for item: AccessibilityItem, of kind: AccessibilityItemKind, with manager: BaseTableManager?) {
        guard let invalidatable = item as? AccessibilityInvalidatable,
              let invalidateDelegate = manager?.delegate as? AccessibilityItemDelegate else {
            return
        }
        invalidatable.setInvalidator(kind: kind, delegate: invalidateDelegate)
    }

    func processTableCell(_ indexPath: IndexPath, _ cell: AccessibilityItem, with manager: BaseTableManager?) {
        if let generator = manager?.generators[indexPath.section][indexPath.row] as? AccessibilityStrategyProvider {
            cell.modifierType.modify(item: cell, generator: generator)
        } else {
            cell.modifierType.modify(item: cell)
        }
    }

    func processTableHeader(_ section: Int, _ view: AccessibilityItem, with manager: BaseTableManager?) {
        if let header = manager?.sections[section] as? AccessibilityStrategyProvider {
            view.modifierType.modify(item: view, generator: header)
        } else {
            view.modifierType.modify(item: view)
        }
    }

    func processTableFooter(_ section: Int, _ view: AccessibilityItem, with manager: BaseTableManager?) {
        // AccessibilityStrategyProvider for a footer generator is not supported yet
        // TODO: SPT-1468
        view.modifierType.modify(item: view)
    }

}

extension BaseTablePlugin {
    static func accessibility() -> BaseTablePlugin<TableEvent> {
        TableAccessibilityPlugin()
    }
}
