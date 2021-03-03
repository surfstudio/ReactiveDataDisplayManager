//
//  CollectionFoldablePlugin.swift
//  ReactiveDataDisplayManager
//
//  Created by Vadim Tikhonov on 11.02.2021.
//

/// Plugin to support `CollectionFoldableItem`
///
/// Allow  expand or collapse child cells
public class CollectionFoldablePlugin: BaseCollectionPlugin<CollectionEvent> {

    public override func process(event: CollectionEvent, with manager: BaseCollectionManager?) {

        switch event {
        case .didSelect(let indexPath):
            guard
                let generator = manager?.generators[indexPath.section][indexPath.row],
                let foldable = generator as? CollectionFoldableItem
            else {
                return
            }

            let visibleGenerators = foldable.childGenerators
                .map { getVisibleGenerators(for: $0) }
                .reduce([], +)

            if foldable.isExpanded {
                visibleGenerators.forEach {
                    manager?.remove($0, needScrollAt: nil, needRemoveEmptySection: false)
                }
            } else {
                if let manager = manager {
                    manager.insert(after: generator, new: visibleGenerators)
                }
            }

            foldable.isExpanded = !foldable.isExpanded
            foldable.didFoldEvent.invoke(with: (foldable.isExpanded))
        default:
            break
        }
    }

}

// MARK: - Private Methods

private extension CollectionFoldablePlugin {

    func getVisibleGenerators(for generator: CollectionCellGenerator) -> [CollectionCellGenerator] {
        if let foldableItem = generator as? CollectionFoldableItem, foldableItem.isExpanded {
            return foldableItem.childGenerators
                .map { getVisibleGenerators(for: $0) }
                .reduce([generator], +)
        } else {
            return [generator]
        }
    }

}

// MARK: - Public init

public extension BaseCollectionPlugin {

    /// Plugin to support `CollectionFoldableItem`
    ///
    /// Allow  expand or collapse child cells
    static func foldable() -> BaseCollectionPlugin<CollectionEvent> {
        CollectionFoldablePlugin()
    }

}
