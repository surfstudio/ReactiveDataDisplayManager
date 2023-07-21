//
//  CollectionAccessibilityPlugin.swift
//  ReactiveDataDisplayManager
//
//  Created by korshunov on 22.05.2023.
//

import UIKit

final class CollectionAccessibilityPlugin: BaseCollectionPlugin<CollectionEvent> {

    let invalidatorCreationBlock: AccessibilityInvalidatorCreationBlock

    init(invalidatorCreationBlock: @escaping AccessibilityInvalidatorCreationBlock) {
        self.invalidatorCreationBlock = invalidatorCreationBlock
    }

    override func process(event: CollectionEvent, with manager: BaseCollectionManager?) {
        switch event {
        case let .willDisplayCell(indexPath, cell):
            guard let cell = cell as? AccessibilityItem else { return }

            processCollectionCell(indexPath, cell, with: manager)
            tryToSetInvalidator(for: cell, of: .cell(indexPath), with: manager)

        case let .invalidatedCellAccessibility(indexPath, cell):
            processCollectionCell(indexPath, cell, with: manager)

        case let .willDisplaySupplementaryView(indexPath, view, kind):
            guard let view = view as? AccessibilityItem else { return }

            switch kind {
            case UICollectionView.elementKindSectionHeader:
                processCollectionHeader(indexPath.section, view, with: manager)
                tryToSetInvalidator(for: view, of: .header(indexPath.section), with: manager)
            case UICollectionView.elementKindSectionFooter:
                processCollectionFooter(indexPath.section, view, with: manager)
                tryToSetInvalidator(for: view, of: .footer(indexPath.section), with: manager)
            default:
                break
            }

        case let .invalidatedHeaderAccessibility(section, view):
            processCollectionHeader(section, view, with: manager)

        case let .invalidatedFooterAccessibility(section, view):
            processCollectionFooter(section, view, with: manager)

        case let .didEndDisplayCell(_, view as UIView), let .didEndDisplayingSupplementaryView(_, view as UIView, _):
            (view as? AccessibilityInvalidatable)?.removeInvalidator()

        default:
            break
        }
    }
}

private extension CollectionAccessibilityPlugin {

    func tryToSetInvalidator(for item: AccessibilityItem, of kind: AccessibilityItemKind, with manager: BaseCollectionManager?) {
        guard let invalidatable = item as? AccessibilityInvalidatable,
                let invalidateDelegate = manager?.delegate as? AccessibilityItemDelegate else {
            return
        }
        invalidatable.setInvalidator(invalidator: invalidatorCreationBlock(item, kind, invalidateDelegate))
    }

    func processCollectionCell(_ indexPath: IndexPath, _ cell: AccessibilityItem, with manager: BaseCollectionManager?) {
        if let generator = manager?.generators[indexPath.section][indexPath.row] as? AccessibilityStrategyProvider {
            cell.modifySelf(with: generator)
        } else {
            cell.modifySelf()
        }
    }

    func processCollectionHeader(_ section: Int, _ view: AccessibilityItem, with manager: BaseCollectionManager?) {
        if let header = manager?.sections[section] as? AccessibilityStrategyProvider {
            view.modifySelf(with: header)
        } else {
            view.modifySelf()
        }
    }

    func processCollectionFooter(_ section: Int, _ view: AccessibilityItem, with manager: BaseCollectionManager?) {
        if let footer = manager?.footers[section] as? AccessibilityStrategyProvider {
            view.modifySelf(with: footer)
        } else {
            view.modifySelf()
        }
    }

}

extension BaseCollectionPlugin {

    /// Creates accessibility plugin with provided invalidator creation block
    ///  - Parameter invalidatorCreationBlock: Block that creates invalidator for item to update accessibility properties on item state changes
    ///  - Note: To setup accessibility your cell should extend `AccessibilityItem`, `AccessibilityInvalidatable` or `AccessibilityContainer`.
    ///  More info in documentation.
    public static func accessibility(invalidatorCreationBlock: @escaping AccessibilityInvalidatorCreationBlock = { item, kind, delegate in
        DelegatedAccessibilityItemInvalidator(item: item,
                                              accessibilityItemKind: kind,
                                              accessibilityDelegate: delegate)
    }) -> BaseCollectionPlugin<CollectionEvent> {
        CollectionAccessibilityPlugin(invalidatorCreationBlock: invalidatorCreationBlock)
    }
}
