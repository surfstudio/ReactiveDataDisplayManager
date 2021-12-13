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

    public typealias Provider = TableSectionsProvider

    // MARK: - Properties

    open var delegate = MovablePluginDelegate<Provider>()
    open var dataSource = MovablePluginDataSource<Provider>()

}

// MARK: - Public init

public extension TableFeaturePlugin {

    /// Plugin to move cells
    ///
    /// Allow moving cells builded with `MovableItem` generators
    static func movable() -> TableMovableItemPlugin {
        .init()
    }

}

/// Plugin to move cells
///
/// Allow moving cells builded with `MovableItem` generators
open class CollectionMovableItemPlugin: CollectionFeaturePlugin, Movable {

    // MARK: - Typealias

    public typealias Provider = CollectionSectionsProvider

    // MARK: - Properties

    open var delegate = MovablePluginDelegate<Provider>()
    open var dataSource = MovablePluginDataSource<Provider>()

}

public extension CollectionFeaturePlugin {

    /// Plugin to move cells
    ///
    /// Allow moving cells builded with `MovableItem` generators
    static func movable() -> CollectionMovableItemPlugin {
        .init()
    }

}
