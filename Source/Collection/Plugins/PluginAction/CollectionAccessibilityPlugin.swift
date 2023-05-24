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
            let generator = manager?.generators[indexPath.section][indexPath.row] as? AccessibilityItem
            if let accessibilityItem = generator ?? cell as? AccessibilityItem {
                accessibilityItem.modifierType.modify(view: cell.contentView, with: accessibilityItem)
            }
        case .willDisplaySupplementaryView(let indexPath, let view, _):
            let generator = manager?.generators[indexPath.section][indexPath.row] as? AccessibilityItem
            if let accessibilityItem = generator ?? view as? AccessibilityItem {
                accessibilityItem.modifierType.modify(view: view, with: accessibilityItem)
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
