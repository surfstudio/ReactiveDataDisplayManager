//
//  TableAccessibilityPlugin.swift
//  ReactiveDataDisplayManager
//
//  Created by korshunov on 25.05.2023.
//

import Foundation

import UIKit

final class TableAccessibilityPlugin: BaseTablePlugin<TableEvent> {

    let invalidatorCreationBlock: AccessibilityInvalidatorCreationBlock

    init(invalidatorCreationBlock: @escaping AccessibilityInvalidatorCreationBlock) {
        self.invalidatorCreationBlock = invalidatorCreationBlock
    }

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
        invalidatable.setInvalidator(invalidator: invalidatorCreationBlock(item, kind, invalidateDelegate))
    }

    func processTableCell(_ indexPath: IndexPath, _ cell: AccessibilityItem, with manager: BaseTableManager?) {
        if let generator = manager?.generators[indexPath.section][indexPath.row] as? AccessibilityStrategyProvider {
            cell.modifySelf(with: generator)
        } else {
            cell.modifySelf()
        }
    }

    func processTableHeader(_ section: Int, _ view: AccessibilityItem, with manager: BaseTableManager?) {
        if let header = manager?.sections[section] as? AccessibilityStrategyProvider {
            view.modifySelf(with: header)
        } else {
            view.modifySelf()
        }
    }

    func processTableFooter(_ section: Int, _ view: AccessibilityItem, with manager: BaseTableManager?) {
        // AccessibilityStrategyProvider for a footer generator is not supported yet
        // TODO: SPT-1468
        view.modifySelf()
    }

}

extension BaseTablePlugin {

    /// Creates accessibility plugin with provided invalidator creation block
    ///  - Parameter invalidatorCreationBlock: Block that creates invalidator for item to update accessibility properties on item state changes
    ///  - Note: To setup accessibility your cell should extend `AccessibilityItem`, `AccessibilityInvalidatable` or `AccessibilityContainer`.
    ///  More info in documentation.
    public static func accessibility(invalidatorCreationBlock: @escaping AccessibilityInvalidatorCreationBlock = { item, kind, delegate in
        DelegatedAccessibilityItemInvalidator(item: item,
                                              accessibilityItemKind: kind,
                                              accessibilityDelegate: delegate)
    }) -> BaseTablePlugin<TableEvent> {
        TableAccessibilityPlugin(invalidatorCreationBlock: invalidatorCreationBlock)
    }
}
