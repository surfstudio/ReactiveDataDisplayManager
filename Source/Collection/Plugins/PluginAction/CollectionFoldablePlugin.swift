//
//  CollectionFoldablePlugin.swift
//  ReactiveDataDisplayManager
//
//  Created by Vadim Tikhonov on 11.02.2021.
//

/// Plugin to support `FoldableItem` in `UICollectionView`
///
/// Allow  expand or collapse child cells
public class CollectionFoldablePlugin: BaseCollectionPlugin<CollectionEvent> {

    // MARK: - Nested types

    public typealias GeneratorType = FoldableItem & CollectionChildrenHolder & FoldableStateToggling

    // MARK: - Plugin body

    public override func process(event: CollectionEvent, with manager: BaseCollectionManager?) {

        switch event {
        case .didSelect(let indexPath):
            guard
                let generator = manager?.sections[indexPath.section].generators[indexPath.row],
                let foldable = generator as? GeneratorType
            else {
                return
            }

            let visibleGenerators = foldable.children
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

            foldable.toggleEpanded()
            foldable.didFoldEvent.invoke(with: (foldable.isExpanded))
        default:
            break
        }
    }

}

// MARK: - Private Methods

private extension CollectionFoldablePlugin {

    func getVisibleGenerators(for generator: CollectionCellGenerator) -> [CollectionCellGenerator] {
        if let foldableItem = generator as? GeneratorType, foldableItem.isExpanded {
            return foldableItem.children
                .map { getVisibleGenerators(for: $0) }
                .reduce([generator], +)
        } else {
            return [generator]
        }
    }

}

// MARK: - Public init

public extension BaseCollectionPlugin {

    /// Plugin to support `FoldableItem` in `UICollectionView`
    ///
    /// Allow  expand or collapse child cells
    static func foldable() -> BaseCollectionPlugin<CollectionEvent> {
        CollectionFoldablePlugin()
    }

}
