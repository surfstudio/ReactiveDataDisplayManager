//
//  DraggablePluginDelegate.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 18.02.2021.
//
#if os(iOS)
import Foundation
import UIKit

/// There is no way to customize system badges with the number of items taken.
@available(iOS 11.0, *)
public struct DragablePreviewParameters {
    var parameters: UIDragPreviewParameters?
    var preview: UIView?

    /// - Parameters:
    ///     - 'parameters': draggable items parameters
    ///     - preview: custom UIView when item dragging
    public init(parameters: UIDragPreviewParameters? = nil, preview: UIView? = nil) {
        self.parameters = parameters
        self.preview = preview
    }
}

/// Delegate based on `DraggableDelegate` protocol.
@available(iOS 11.0, *)
open class DraggablePluginDelegate<Provider: GeneratorsProvider> {

    // MARK: - Typealias

    public typealias GeneratorType = DragAndDroppableItemSource

    public init() { }

    // MARK: - Internal Properties

    var draggableParameters: DragablePreviewParameters?

}

// MARK: - DraggableDelegate

@available(iOS 11.0, *)
extension DraggablePluginDelegate: DraggableDelegate {

    /// Method provides the initial set of items (if any) to drag.
    /// - parameters:
    ///     - indexPath: index path of the item to drag.
    ///     - provider: wrapped collection of sections and generators
    /// - returns: items to drag or an empty array if dragging the selected item is not possible
    /// - warning: Currently supports single item drag
    public func makeDragItems(at indexPath: IndexPath, with provider: Provider?) -> [UIDragItem] {
        guard let generator = provider?.generators[safe: indexPath.section]?[safe: indexPath.row] as? GeneratorType else { return [] }
        let mainDragItem = makeDragItem(for: generator.dropableItem)

        if let preview = draggableParameters?.preview {
            mainDragItem.previewProvider = { .init(view: preview) }
        }

        return [mainDragItem]
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
#endif
