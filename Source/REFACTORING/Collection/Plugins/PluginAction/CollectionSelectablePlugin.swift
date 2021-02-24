//
//  CollectionSelectablePlugin.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 11.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

// Adds support for Selectable item triggering
public class CollectionSelectablePlugin: BaseCollectionPlugin<CollectionEvent> {

    // MARK: - Initialization

    public override init() { }

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
        default:
            break
        }
    }

}
