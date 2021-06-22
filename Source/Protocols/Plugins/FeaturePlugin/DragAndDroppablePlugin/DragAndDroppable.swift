//
//  DragAndDroppable.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 18.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

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

    func makeDragItems(at indexPath: IndexPath, with provider: Provider?) -> [UIDragItem]
}

@available(iOS 11.0, *)
public protocol DroppableDelegate: AnyObject {
    associatedtype Provider: GeneratorsProvider
    associatedtype CoordinatorType: NSObjectProtocol

    func didUpdateItem(with destinationIndexPath: IndexPath?, in view: DragAndDroppableView) -> UIDropOperation
    func performDrop<Collection: UIView, Animation: RawRepresentable>(with coordinator: DropCoordinatorWrapper<CoordinatorType>,
                                                                      and provider: Provider?,
                                                                      view: Collection,
                                                                      animator: Animator<Collection>?,
                                                                      modifier: Modifier<Collection, Animation>?)
}
