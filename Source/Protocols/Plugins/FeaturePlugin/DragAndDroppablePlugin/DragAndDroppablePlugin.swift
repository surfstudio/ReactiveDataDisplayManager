//
//  DragAndDroppablePlugin.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 18.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//
#if os(iOS)
import UIKit
import Foundation

/// Plugin to drag and drop cells
///
/// Allow dragging and dropping cells builded with `DragAndDroppableItemSource` generators
@available(iOS 11.0, *)
open class TableDragAndDroppablePlugin: TableFeaturePlugin, DragAndDroppable {

    // MARK: - Typealias

    public typealias Provider = TableSectionsProvider

    // MARK: - Properties

    open var draggableDelegate = DraggablePluginDelegate<Provider>()
    open var droppableDelegate = DroppablePluginDelegate<Provider, UITableViewDropCoordinator>()

    // MARK: - Initializations

    init(dropStrategy: StrategyDropable) {
        droppableDelegate.dropStrategy = dropStrategy
    }

}

// MARK: - Public init

public extension TableFeaturePlugin {

    /// Plugin to drag and drop cells
    ///
    /// Allow dragging and dropping cells builded with `DragAndDroppableItemSource` generators by section
    /// - parameters:
    ///     - sections: allow dropping across sections (all or current)
    @available(iOS 11.0, *)
    static func dragAndDroppable(by sections: DropStrategy = .all) -> TableDragAndDroppablePlugin {
        .init(dropStrategy: sections)
    }

}

/// Plugin to drag and drop cells
///
/// Allow dragging and dropping cells builded with `DragAndDroppableItemSource` generators
@available(iOS 11.0, *)
open class CollectionDragAndDroppablePlugin: CollectionFeaturePlugin, DragAndDroppable {

    // MARK: - Typealias

    public typealias Provider = CollectionSectionsProvider

    // MARK: - Properties

    open var draggableDelegate = DraggablePluginDelegate<Provider>()
    open var droppableDelegate = DroppablePluginDelegate<Provider, UICollectionViewDropCoordinator>()

    // MARK: - Initializations

    init(dropStrategy: StrategyDropable) {
        droppableDelegate.dropStrategy = dropStrategy
    }

}

public extension CollectionFeaturePlugin {

    /// Plugin to drag and drop cells
    ///
    /// Allow dragging and dropping cells builded with `DragAndDroppableItemSource` generators by section
    /// - parameters:
    ///     - sections: allow dropping across sections (all or current)
    @available(iOS 11.0, *)
    static func dragAndDroppable(by sections: DropStrategy = .all) -> CollectionDragAndDroppablePlugin {
        .init(dropStrategy: sections)
    }

}
#endif
