//
//  CollectionAccessibilityPlugin.swift
//  ReactiveDataDisplayManager
//
//  Created by korshunov on 22.05.2023.
//

import UIKit

final class CollectionAccessibilityPlugin: BaseCollectionPlugin<CollectionEvent> {

    override func process(event: CollectionEvent, with manager: BaseCollectionManager?) {
        switch event {
        case let .willDisplayCell(indexPath, cell):
            processCollectionCell(indexPath, cell, with: manager)
            (cell as? AccessibilityInvalidatable)?.setInvalidator(kind: .cell(indexPath), delegate: manager?.delegate)

        case let .invalidatedCellAccessibility(indexPath, cell):
            processCollectionCell(indexPath, cell, with: manager)

        case let .willDisplaySupplementaryView(indexPath, view, kind):
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                processCollectionHeader(indexPath.section, view, with: manager)
                (view as? AccessibilityInvalidatable)?.setInvalidator(kind: .header(indexPath.section), delegate: manager?.delegate)
            case UICollectionView.elementKindSectionFooter:
                processCollectionFooter(indexPath.section, view, with: manager)
                (view as? AccessibilityInvalidatable)?.setInvalidator(kind: .footer(indexPath.section), delegate: manager?.delegate)
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

    private func processCollectionCell(_ indexPath: IndexPath, _ cell: UICollectionViewCell, with manager: BaseCollectionManager?) {
        guard let accessibilityItem = cell as? AccessibilityItem else {
            return
        }
        if let generator = manager?.generators[indexPath.section][indexPath.row] as? AccessibilityStrategyProvider {
            accessibilityItem.modifierType.modify(item: accessibilityItem, generator: generator)
        } else {
            accessibilityItem.modifierType.modify(item: accessibilityItem)
        }
    }

    private func processCollectionHeader(_ section: Int, _ view: UICollectionReusableView, with manager: BaseCollectionManager?) {
        guard let accessibilityItem = view as? AccessibilityItem else {
            return
        }
        if let header = manager?.sections[section] as? AccessibilityStrategyProvider {
            accessibilityItem.modifierType.modify(item: accessibilityItem, generator: header)
        } else {
            accessibilityItem.modifierType.modify(item: accessibilityItem)
        }
    }

    private func processCollectionFooter(_ section: Int, _ view: UICollectionReusableView, with manager: BaseCollectionManager?) {
        guard let accessibilityItem = view as? AccessibilityItem else {
            return
        }
        if let footer = manager?.footers[section] as? AccessibilityStrategyProvider {
            accessibilityItem.modifierType.modify(item: accessibilityItem, generator: footer)
        } else {
            accessibilityItem.modifierType.modify(item: accessibilityItem)
        }
    }

}

extension BaseCollectionPlugin {
    static func accessibility() -> BaseCollectionPlugin<CollectionEvent> {
        CollectionAccessibilityPlugin()
    }
}
