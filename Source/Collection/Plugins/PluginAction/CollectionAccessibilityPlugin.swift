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
            if let customItem = cell as? CustomAccessibilityItem {
                customItem.setupAccessibility()
            } else {
                AccessibilityParser.processAndApply(process: cell.contentView, applyTo: cell)
                if let generator = manager?.generators[indexPath.section][indexPath.row],
                    generator is SelectableItem || generator is FoldableItem {
                    cell.accessibilityTraits.insert(.button)
                }
            }
        case .willDisplaySupplementaryView(let indexPath, let view, let elementKind):
            if let customItem = view as? CustomAccessibilityItem {
                customItem.setupAccessibility()
            } else {
                AccessibilityParser.processAndApply(process: view, applyTo: view)
                var generator: Any?
                switch elementKind {
                case UICollectionView.elementKindSectionHeader:
                    generator = manager?.sections[indexPath.section]
                    view.accessibilityTraits.insert(.header)
                case UICollectionView.elementKindSectionFooter:
                    generator = manager?.footers[indexPath.section]
                default:
                    break
                }
                if let generator = generator, generator is SelectableItem || generator is FoldableItem {
                    view.accessibilityTraits.insert(.button)
                }
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
