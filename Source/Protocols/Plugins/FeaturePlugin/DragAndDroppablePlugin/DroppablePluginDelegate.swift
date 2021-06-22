//
//  DroppablePluginDelegate.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 18.02.2021.
//

import Foundation
import UIKit

fileprivate enum Constants {
    static let automaticAnimationValue = 100
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

    open func performDrop<View: UIView, Animation: RawRepresentable>(with coordinator: Coordinator, and provider: Provider?, modifier: Modifier<View, Animation>?) {
        guard
            coordinator.proposal.operation == .move,
            let destinationIndexPath = coordinator.destinationIndexPath
        else { return }

        reorderItems(with: destinationIndexPath, coordinator: coordinator, provider: provider, modifier: modifier)
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

    func reorderItems<View: UIView, Animation: RawRepresentable>(with destinationIndexPath: IndexPath,
                                                                 coordinator: Coordinator,
                                                                 provider: Provider?,
                                                                 modifier: Modifier<View, Animation>?) {
        guard let value = Constants.automaticAnimationValue as? Animation.RawValue, let animation = Animation(rawValue: value) else { return }

        let indexPaths = coordinator.items.enumerated().compactMap { (index, element) -> (source: IndexPath?, target: IndexPath?) in
            guard
                let sourceIndexPath = element.sourceIndexPath,
                destinationIndexPath != sourceIndexPath,
                let itemToMove = provider?.generators[safe: sourceIndexPath.section]?[safe: sourceIndexPath.row]
            else { return (nil, nil) }

            provider?.generators[sourceIndexPath.section].remove(at: sourceIndexPath.row)
            provider?.generators[destinationIndexPath.section].insert(itemToMove, at: destinationIndexPath.row + index)

            let targetIndexPath = IndexPath(row: destinationIndexPath.row + index, section: destinationIndexPath.section)
            return (sourceIndexPath, targetIndexPath)
        }

        modifier?.replace(at: indexPaths.compactMap { $0.source }, on: indexPaths.compactMap { $0.target }, with: animation, and: animation)

        for (index, item) in coordinator.items.enumerated() {
            guard let indexPath = indexPaths[safe: index], let targetIndexPath = indexPath.target else { continue }
            coordinator.drop(item.dragItem, toItemAt: targetIndexPath)
        }
    }

}
