//
//  DroppablePluginDelegate.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 18.02.2021.
//
#if os(iOS)
import Foundation
import UIKit

fileprivate enum Constants {
    static let animation = CollectionItemAnimation.animated.rawValue
}

/// Delegate based on `DroppableDelegate` protocol.
@available(iOS 11.0, *)
open class DroppablePluginDelegate<Provider: GeneratorsProvider, CoordinatorType: NSObjectProtocol>: DroppableDelegate {

    // MARK: - Typealias

    public typealias Coordinator = DropCoordinatorWrapper<CoordinatorType>
    public typealias GeneratorType = DragAndDroppableItemSource

    public init() { }

    // MARK: - Internal Properties

    var dropStrategy: StrategyDropable?
    var droppableParameters: UIDragPreviewParameters?
    var cellDidChangePosition: ((ResultChangeCellPosition) -> Void)?

    // MARK: - DroppableDelegate

    /// Method allows you to include drag and drop data in the collection.
    /// - parameters:
    ///     - coordinator: wrapper for UITableViewDropCoordinator or UICollectionViewDropCoordinator
    ///     - provider: wrapped collection of sections and generators
    ///     - view: the collection that received the drop
    ///     - animator: an animator object for animating the dropping of elements into the view
    ///     - modifier: object to modify view after the dropping of elements into the view
    // swiftlint:disable:next function_parameter_count
    open func performDrop<Collection: UIView, Animation: RawRepresentable>(with coordinator: Coordinator,
                                                                           and provider: Provider?,
                                                                           view: Collection,
                                                                           modifier: Modifier<Collection, Animation>?) {
        guard
            coordinator.proposal.operation == .move,
            let destinationIndexPath = coordinator.destinationIndexPath
        else { return }

        reorderItems(with: destinationIndexPath,
                     coordinator: coordinator,
                     provider: provider,
                     view: view,
                     modifier: modifier)
    }

    /// Method allow to determine a type of operation when the user dropping items
    /// - parameters:
    ///     - destinationIndexPath: index path at which the items would be dropped.
    ///     - view: the collection that’s tracking the dragged content.
    /// - returns: Operation types that determine how a drag and drop activity resolves when the user drops a drag item.
    open func didUpdateItem(with destinationIndexPath: IndexPath?, in view: DragAndDroppableView) -> UIDropOperation {
        guard view.hasActiveDrag else {
            return .forbidden
        }

        return .move
    }

}

// MARK: - Private Methods

@available(iOS 11.0, *)
private extension DroppablePluginDelegate {

    // swiftlint:disable:next function_parameter_count
    func reorderItems<Collection: UIView, Animation: RawRepresentable>(with destinationIndexPath: IndexPath,
                                                                       coordinator: Coordinator,
                                                                       provider: Provider?,
                                                                       view: Collection,
                                                                       modifier: Modifier<Collection, Animation>?) {
        guard
            let value = Constants.animation as? Animation.RawValue,
            let animation = Animation(rawValue: value),
            let generatorsCount = provider?.generators[destinationIndexPath.section].count,
            destinationIndexPath.row < generatorsCount
        else { return }

        var removed = [Provider.CellGeneratorType]()

        coordinator.items.enumerated().forEach {
            guard
                let sourceIndexPath = $0.element.sourceIndexPath,
                destinationIndexPath != sourceIndexPath,
                dropStrategy?.canDrop(from: sourceIndexPath, to: destinationIndexPath) ?? true,
                let itemToMove = provider?.generators[sourceIndexPath.section][sourceIndexPath.row]
            else { return }
            sourceIndexPath > destinationIndexPath || sourceIndexPath.section < destinationIndexPath.section
                ? removed.insert(itemToMove, at: 0)
                : removed.append(itemToMove)
        }

        removed.enumerated().forEach {
            guard
                let sourceIndexPath = getIndexPath(for: $0.element, provider: provider),
                let itemToMove = provider?.generators[sourceIndexPath.section].remove(at: sourceIndexPath.row),
                let generator = itemToMove as? GeneratorType
            else { return }

            provider?.generators[destinationIndexPath.section].insert(itemToMove, at: destinationIndexPath.row)
            modifier?.replace(at: [sourceIndexPath], on: [destinationIndexPath], with: (remove: animation, insert: animation))
            coordinator.drop(coordinator.items[$0.offset].dragItem, toItemAt: destinationIndexPath)

            cellDidChangePosition?(.init(id: generator.id, oldIndex: sourceIndexPath, newIndex: destinationIndexPath))
        }
    }

    func getIndexPath(for item: Provider.CellGeneratorType, provider: Provider?) -> IndexPath? {
        guard let generators = provider?.generators as? [[GeneratorType]],
              let generator = item as? GeneratorType,
              let section = generators.firstIndex(where: { $0.contains(where: { $0 === generator }) }),
              let row = generators[section].firstIndex(where: { $0 === generator }) else { return nil }
        return IndexPath(row: row, section: section)
    }

}
#endif
