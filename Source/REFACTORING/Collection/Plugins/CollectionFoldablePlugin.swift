//
//  CollectionFoldablePlugin.swift
//  ReactiveDataDisplayManager
//
//  Created by Vadim Tikhonov on 11.02.2021.
//

public class CollectionFoldablePlugin: BaseCollectionPlugin<CollectionEvent> {

    public override init() {}

    public override func process(event: CollectionEvent, with manager: BaseCollectionManager?) {

        switch event {
        case .didSelect(let indexPath):
            guard
                let generator = manager?.generators[indexPath.section][indexPath.row],
                let foldable = generator as? CollectionFoldableItem
            else {
                return
            }
            
            if foldable.isExpanded {
                foldable.childGenerators.forEach { manager?.remove($0,
                                                                   needScrollAt: nil,
                                                                   needRemoveEmptySection: false)
                }
            } else {
                if let manager = manager as? ManualCollectionManager {
                    manager.insert(after: generator, new: foldable.childGenerators)
                }
            }

            foldable.isExpanded = !foldable.isExpanded
            foldable.didFoldEvent.invoke(with: (foldable.isExpanded))
        default:
            break
        }
    }

}
