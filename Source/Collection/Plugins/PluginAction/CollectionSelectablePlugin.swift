//
//  CollectionSelectablePlugin.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 11.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

/// Plugin to support `SelectableItem`
///
/// Handle `didSelect` event inside generator and `deselectItem`
public class CollectionSelectablePlugin: BaseCollectionPlugin<CollectionEvent> {

    // MARK: - BaseCollectionPlugin

    public override func process(event: CollectionEvent, with manager: BaseCollectionManager?) {
        switch event {
        case .didSelect(let indexPath):
            guard let selectable = manager?.generators[indexPath.section][indexPath.row] as? SelectableItem else {
                return
            }
            selectable.didSelectEvent.invoke(with: ())

            if selectable.isNeedDeselect {
                manager?.view?.deselectItem(at: indexPath, animated: true)
            }
        case .didDeselect(let indexPath):
            guard let selectable = manager?.generators[indexPath.section][indexPath.row] as? SelectableItem else {
                return
            }
            selectable.didDeselectEvent.invoke(with: ())
        default:
            break
        }
    }

}

// MARK: - Public init

public extension BaseCollectionPlugin {

    /// Plugin to support `SelectableItem`
    ///
    /// Handle `didSelect` event inside generator and `deselectItem`
    static func selectable() -> CollectionSelectablePlugin {
        .init()
    }

}
