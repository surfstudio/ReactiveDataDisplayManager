//
//  DragAndDroppable.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 18.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//
#if os(iOS)
import Foundation
import UIKit

@available(iOS 11.0, *)
public protocol DragAndDroppable {
    associatedtype DraggableDelegateType: DraggableDelegate
    associatedtype DroppableDelegateType: DroppableDelegate

    var draggableDelegate: DraggableDelegateType { get set }
    var droppableDelegate: DroppableDelegateType { get set }
}

@available(iOS 11.0, *)
public protocol DraggableDelegate: AnyObject {
    associatedtype Provider: GeneratorsProvider

    /// Method provides the initial set of items (if any) to drag.
    /// - parameters:
    ///     - indexPath: index path of the item to drag.
    ///     - provider: wrapped collection of sections and generators
    /// - returns: items to drag or an empty array if dragging the selected item is not possible
    func makeDragItems(at indexPath: IndexPath, with provider: Provider?) -> [UIDragItem]
}

@available(iOS 11.0, *)
public protocol DroppableDelegate: AnyObject {
    associatedtype Provider: GeneratorsProvider
    associatedtype CoordinatorType: NSObjectProtocol

    /// Method allow to determine a type of operation when the user dropping items
    /// - parameters:
    ///     - destinationIndexPath: index path at which the items would be dropped.
    ///     - view: the collection that’s tracking the dragged content.
    /// - returns: Operation types that determine how a drag and drop activity resolves when the user drops a drag item.
    func didUpdateItem(with destinationIndexPath: IndexPath?, in view: DragAndDroppableView) -> UIDropOperation

    /// Method allows you to include drag and drop data in the collection.
    /// - parameters:
    ///     - coordinator: wrapper for UITableViewDropCoordinator or UICollectionViewDropCoordinator
    ///     - provider: wrapped collection of sections and generators
    ///     - view: the collection that received the drop
    ///     - animator: an animator object for animating the dropping of elements into the view
    ///     - modifier: object to modify view after the dropping of elements into the view
    func performDrop<Collection: UIView, Animation: RawRepresentable>(with coordinator: DropCoordinatorWrapper<CoordinatorType>,
                                                                      and provider: Provider?,
                                                                      view: Collection,
                                                                      modifier: Modifier<Collection, Animation>?)
}
#endif
