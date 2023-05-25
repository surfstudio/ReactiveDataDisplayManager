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
        case .willDisplayCell(let indexPath, let cell):
            if let accessibilityItem = cell as? AccessibilityItem {
                let generator = manager?.generators[indexPath.section][indexPath.row] as? AccessibilityStrategyProvider
                accessibilityItem.modifierType.modify(view: cell.contentView, with: accessibilityItem, generator: generator)
            }
        case .willDisplaySupplementaryView(let indexPath, let view, let kind):
            guard [UICollectionView.elementKindSectionHeader, UICollectionView.elementKindSectionFooter].contains(kind) else {
                return
            }
            if let accessibilityItem = view as? AccessibilityItem {
                let generator = manager?.generators[indexPath.section][indexPath.row] as? AccessibilityStrategyProvider
                accessibilityItem.modifierType.modify(view: view, with: accessibilityItem, generator: generator)
            }
        default:
            break
        }
    }
}

extension BaseCollectionPlugin {
    static func accessibility() -> BaseCollectionPlugin<CollectionEvent> {
        CollectionAccessibilityPlugin()
    }
}
