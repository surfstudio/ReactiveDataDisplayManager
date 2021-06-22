//
//  DroppablePluginDelegate.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 18.02.2021.
//

import Foundation
import UIKit

fileprivate enum Constants {
    static let noneAnimation = 5
}

/// Delegate based on `DroppableDelegate` protocol.
@available(iOS 11.0, *)
open class DroppablePluginDelegate<Provider: GeneratorsProvider, CoordinatorType: NSObjectProtocol> {

    // MARK: - Typealias

    public typealias Coordinator = DropCoordinatorWrapper<CoordinatorType>
    public typealias GeneratorType = DragAndDroppableItemSource

}

// MARK: - DroppableDelegate

@available(iOS 11.0, *)
extension DroppablePluginDelegate: DroppableDelegate {

    open func performDrop<Collection: UIView, Animation: RawRepresentable>(with coordinator: Coordinator,
                                                                           and provider: Provider?,
                                                                           view: Collection,
                                                                           animator: Animator<Collection>?,
                                                                           modifier: Modifier<Collection, Animation>?) {
        guard
            coordinator.proposal.operation == .move,
            let destinationIndexPath = coordinator.destinationIndexPath
        else { return }

        reorderItems(with: destinationIndexPath, coordinator: coordinator, provider: provider, view: view, animator: animator, modifier: modifier)
    }

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

    func reorderItems<Collection: UIView, Animation: RawRepresentable>(with destinationIndexPath: IndexPath,
                                                                       coordinator: Coordinator,
                                                                       provider: Provider?,
                                                                       view: Collection,
                                                                       animator: Animator<Collection>?,
                                                                       modifier: Modifier<Collection, Animation>?) {
        guard
            let value = Constants.noneAnimation as? Animation.RawValue,
            let animation = Animation(rawValue: value)
        else { return }

        coordinator.items.forEach {
            guard
                let sourceIndexPath = $0.sourceIndexPath,
                destinationIndexPath != sourceIndexPath,
                let itemToMove = provider?.generators[safe: sourceIndexPath.section]?[safe: sourceIndexPath.row]
            else { return }

            animator?.perform(in: view, animated: true, operation: { [weak provider, modifier] in
                provider?.generators[sourceIndexPath.section].remove(at: sourceIndexPath.row)
                provider?.generators[destinationIndexPath.section].insert(itemToMove, at: destinationIndexPath.row)
                modifier?.replace(at: [sourceIndexPath], on: [destinationIndexPath], with: animation, and: animation)
            })

            coordinator.drop($0.dragItem, toItemAt: destinationIndexPath)
        }
    }

}
