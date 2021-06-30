//
//  CollectionDragAndDropDelegate.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 18.02.2021.
//
#if os(iOS)
import UIKit

@available(iOS 11.0, *)
public protocol CollectionDragAndDropDelegate: UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    var draggableDelegate: DraggablePluginDelegate<CollectionGeneratorsProvider>? { get set }
    var droppableDelegate: DroppablePluginDelegate<CollectionGeneratorsProvider, UICollectionViewDropCoordinator>? { get set }
}
#endif
