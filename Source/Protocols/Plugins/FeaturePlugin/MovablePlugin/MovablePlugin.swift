//
//  MovablePlugin.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 15.04.2021.
//

import UIKit
import Foundation

/// Plugin to move cells
///
/// Allow moving cells builded with `MovableItem` generators
open class TableMovableItemPlugin: TableFeaturePlugin, Movable {

    // MARK: - Typealias

    public typealias Provider = TableGeneratorsProvider

    // MARK: - Properties

    open var delegate = MovablePluginDelegate<Provider>()
    open var dataSource = MovablePluginDataSource<Provider>()

    // MARK: - Initialization

    public init(cellDidChangePosition: ((ResultChangeCellPosition) -> Void)? = nil) {
        dataSource.cellDidChangePosition = cellDidChangePosition
    }

}

// MARK: - Public init

public extension TableFeaturePlugin {

    /// Plugin to move cells
    ///
    /// Allow moving cells builded with `MovableItem` generators
    static func movable() -> TableMovableItemPlugin {
        .init()
    }

    /// Plugin to move cells
    ///
    /// Allow moving cells builded with `MovableItem` generators
    ///
    /// - Parameters:
    ///     - cellDidChangePosition: signal that the cell has been moved
    static func movable(cellDidChangePosition: ((ResultChangeCellPosition) -> Void)?) -> TableMovableItemPlugin {
        .init(cellDidChangePosition: cellDidChangePosition)
    }

}

/// Plugin to move cells
///
/// Allow moving cells builded with `MovableItem` generators
open class CollectionMovableItemPlugin: CollectionFeaturePlugin, Movable {

    // MARK: - Typealias

    public typealias Provider = CollectionGeneratorsProvider

    // MARK: - Properties

    open var delegate = MovablePluginDelegate<Provider>()
    open var dataSource = MovablePluginDataSource<Provider>()

    // MARK: - Initialization

    public init(cellDidChangePosition: ((ResultChangeCellPosition) -> Void)? = nil) {
        dataSource.cellDidChangePosition = cellDidChangePosition
    }

}

public extension CollectionFeaturePlugin {

    /// Plugin to move cells
    ///
    /// Allow moving cells builded with `MovableItem` generators
    static func movable() -> CollectionMovableItemPlugin {
        .init()
    }

    /// Plugin to move cells
    ///
    /// Allow moving cells builded with `MovableItem` generators
    ///
    /// - Parameters:
    ///     - cellDidChangePosition: signal that the cell has been moved
    static func movable(cellDidChangePosition: ((ResultChangeCellPosition) -> Void)?) -> CollectionMovableItemPlugin {
        .init(cellDidChangePosition: cellDidChangePosition)
    }

}
