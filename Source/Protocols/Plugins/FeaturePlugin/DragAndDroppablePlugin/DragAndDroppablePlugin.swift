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

    public typealias Provider = TableGeneratorsProvider

    // MARK: - Properties

    open var draggableDelegate = DraggablePluginDelegate<Provider>()
    open var droppableDelegate = DroppablePluginDelegate<Provider, UITableViewDropCoordinator>()

    // MARK: - Initializations

    init(dropStrategy: StrategyDropable,
         draggableParameters: DragablePreviewParameters?,
         droppableParameters: UIDragPreviewParameters?,
         cellDidChangePosition: ((ResultChangeCellPosition) -> Void)? = nil) {

        droppableDelegate.dropStrategy = dropStrategy
        droppableDelegate.droppableParameters = droppableParameters
        draggableDelegate.draggableParameters = draggableParameters
        droppableDelegate.cellDidChangePosition = cellDidChangePosition
    }

}

// MARK: - Public init

public extension TableFeaturePlugin {

    /// Plugin to drag and drop cells
    ///
    /// Allow dragging and dropping cells builded with `DragAndDroppableItemSource` generators by section
    /// - parameters:
    ///     - sections: allow dropping across sections (all or current)
    ///     - draggableParameters: setting view display when dragging
    ///     - droppableParameters: setting view display when dropp
    ///     - setting view display when dropping
    @available(iOS 11.0, *)
    static func dragAndDroppable(by sections: DropStrategy = .all,
                                 draggableParameters: DragablePreviewParameters? = nil,
                                 droppableParameters: UIDragPreviewParameters? = nil,
                                 positionChanged: ((ResultChangeCellPosition) -> Void)? = nil) -> TableDragAndDroppablePlugin {

        return .init(dropStrategy: sections,
                     draggableParameters: draggableParameters,
                     droppableParameters: droppableParameters,
                     cellDidChangePosition: positionChanged)
    }

}

/// Plugin to drag and drop cells
///
/// Allow dragging and dropping cells builded with `DragAndDroppableItemSource` generators
@available(iOS 11.0, *)
open class CollectionDragAndDroppablePlugin: CollectionFeaturePlugin, DragAndDroppable {

    // MARK: - Typealias

    public typealias Provider = CollectionGeneratorsProvider

    // MARK: - Properties

    open var draggableDelegate = DraggablePluginDelegate<Provider>()
    open var droppableDelegate = DroppablePluginDelegate<Provider, UICollectionViewDropCoordinator>()

    // MARK: - Initializations

    init(dropStrategy: StrategyDropable,
         draggableParameters: DragablePreviewParameters?,
         droppableParameters: UIDragPreviewParameters?,
         cellDidChangePosition: ((ResultChangeCellPosition) -> Void)? = nil) {
        draggableDelegate.draggableParameters = draggableParameters
        droppableDelegate.droppableParameters = droppableParameters
        droppableDelegate.dropStrategy = dropStrategy
        droppableDelegate.cellDidChangePosition = cellDidChangePosition
    }

}

public extension CollectionFeaturePlugin {

    /// Plugin to drag and drop cells
    ///
    /// Allow dragging and dropping cells builded with `DragAndDroppableItemSource` generators by section
    /// - parameters:
    ///     - sections: allow dropping across sections (all or current)
    ///     - draggableParameters: setting view display when dragging
    ///     - droppableParameters: setting view display when dropp
    ///     - cellDidChangePosition: signal that the cell has been moved
    @available(iOS 11.0, *)
    static func dragAndDroppable(by sections: DropStrategy = .all,
                                 draggableParameters: DragablePreviewParameters? = nil,
                                 droppableParameters: UIDragPreviewParameters? = nil,
                                 positionChanged: ((ResultChangeCellPosition) -> Void)? = nil) -> CollectionDragAndDroppablePlugin {

        return .init(dropStrategy: sections,
                     draggableParameters: draggableParameters,
                     droppableParameters: droppableParameters,
                     cellDidChangePosition: positionChanged)
    }

}
#endif
