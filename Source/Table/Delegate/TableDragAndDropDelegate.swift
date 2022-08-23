//
//  TableDragAndDropDelegate.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 18.02.2021.
//
#if os(iOS)
import UIKit

@available(iOS 11.0, *)
public protocol TableDragAndDropDelegate: UITableViewDropDelegate, UITableViewDragDelegate {
    var droppableDelegate: DroppablePluginDelegate<TableSectionsProvider, UITableViewDropCoordinator>? { get set }
    var draggableDelegate: DraggablePluginDelegate<TableSectionsProvider>? { get set }
}
#endif
