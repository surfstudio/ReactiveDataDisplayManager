//
//  DraggablePluginDelegate.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 18.02.2021.
//

import Foundation
import UIKit

/// Delegate based on `DraggableDelegate` protocol.
@available(iOS 11.0, *)
open class DraggablePluginDelegate<Provider: GeneratorsProvider> {

    // MARK: - Typealias

    public typealias GeneratorType = DragAndDroppableItemSource

}

// MARK: - DraggableDelegate

@available(iOS 11.0, *)
extension DraggablePluginDelegate: DraggableDelegate {

    /// Method provides the initial set of items (if any) to drag.
    /// - parameters:
    ///     - indexPath: index path of the item to drag.
    ///     - provider: wrapped collection of sections and generators
    /// - returns: items to drag or an empty array if dragging the selected item is not possible
    public func makeDragItems(at indexPath: IndexPath, with provider: Provider?) -> [UIDragItem] {
        guard let generator = provider?.generators[safe: indexPath.section]?[safe: indexPath.row] as? GeneratorType else { return [] }
        let mainDragItem = makeDragItem(for: generator.item)
        let items = [mainDragItem] + generator.associatedGenerators.compactMap(makeDragItem(for:))
        return items
    }

}

// MARK: - Private Methods

@available(iOS 11.0, *)
private extension DraggablePluginDelegate {

    func makeDragItem(for item: DragAndDroppableItem) -> UIDragItem {
        let itemProvider = NSItemProvider(object: item.identifier)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return dragItem
    }

}
