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
            guard let accessibilityItem = cell as? AccessibilityItem else {
                return
            }
            let generator = manager?.generators[indexPath.section][indexPath.row] as? AccessibilityStrategyProvider
            accessibilityItem.modifierType.modify(view: cell.contentView, with: accessibilityItem, generator: generator)

        case .willDisplaySupplementaryView(let indexPath, let view, let kind):
            guard let accessibilityItem = view as? AccessibilityItem else {
                return
            }

            var supplementaryGenerator: AccessibilityStrategyProvider?
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                supplementaryGenerator = manager?.sections[indexPath.section] as? AccessibilityStrategyProvider
            case UICollectionView.elementKindSectionFooter:
                supplementaryGenerator = manager?.footers[indexPath.section] as? AccessibilityStrategyProvider
            default:
                break
            }
            accessibilityItem.modifierType.modify(view: view, with: accessibilityItem, generator: supplementaryGenerator)

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
