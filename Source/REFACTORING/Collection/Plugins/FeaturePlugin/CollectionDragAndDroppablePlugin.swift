//
//  CollectionDragAndDroppablePlugin.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 18.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
open class CollectionDragAndDroppablePlugin: CollectionDragAndDroppable {

    // MARK: - Initialization

    public init() {}

    // MARK: - CollectionDragAndDroppable

    open func makeDragItems(at indexPath: IndexPath, with manager: BaseCollectionManager?) -> [UIDragItem] {
        guard let generator = manager?.generators[safe: indexPath.section]?[safe: indexPath.row] as? DragAndDroppableItem else { return [] }
        let itemProvider = NSItemProvider(object: generator.draggableIdentifier)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = generator
        return [dragItem]
    }

    open func performDrop(with coordinator: UICollectionViewDropCoordinator, and manager: BaseCollectionManager?) {
        guard
            coordinator.proposal.operation == .move,
            let destinationIndexPath = coordinator.destinationIndexPath
        else { return }

        reorderItems(with: destinationIndexPath, coordinator: coordinator, manager: manager)
    }

    open func didUpdateItem(with destinationIndexPath: IndexPath?, and manager: BaseCollectionManager?) -> UICollectionViewDropProposal {
        guard let hasActiveDrag = manager?.view?.hasActiveDrag, hasActiveDrag else {
            return UICollectionViewDropProposal(operation: .forbidden)
        }

        return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }

}

// MARK: - Private methods

@available(iOS 11.0, *)
private extension CollectionDragAndDroppablePlugin {

    func reorderItems(with destinationIndexPath: IndexPath, coordinator: UICollectionViewDropCoordinator, manager: BaseCollectionManager?) {
        guard
            let item = coordinator.items.first,
            let sourceIndexPath = item.sourceIndexPath,
            let manager = manager,
            let view = manager.view
        else { return }

        manager.animator?.perform(in: view) {
            let itemToMove = manager.generators[sourceIndexPath.section][sourceIndexPath.row]
            manager.generators[sourceIndexPath.section].remove(at: sourceIndexPath.row)
            manager.generators[destinationIndexPath.section].insert(itemToMove, at: destinationIndexPath.row)

            view.deleteItems(at: [sourceIndexPath])
            view.insertItems(at: [destinationIndexPath])
        }

        coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
    }

}
