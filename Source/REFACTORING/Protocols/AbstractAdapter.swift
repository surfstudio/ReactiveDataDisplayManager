//
//  AbstractAdapter.swift
//  ReactiveDataDisplayManager
//
//  Created by Aleksandr Smirnov on 20.11.2020.
//  Copyright © 2020 Александр Кравченков. All rights reserved.
//

import Foundation

///Determines interface and dependencies for any collection adapter
public protocol AbstractAdapter: class {

    // MARK: Associated types

    associatedtype CollectionType
    associatedtype CellGeneratorType
    associatedtype CollectionDelegateType
    associatedtype CollectionDataSourceType
    associatedtype CollectionStateManagerType

    // MARK: Support methods

    init(collection: CollectionType,
        stateManager: CollectionStateManagerType,
        delegate: CollectionDelegateType,
        dataSource: CollectionDataSourceType)

    // MARK: - Support methods (Proxies for AbstractAdapter methods)

    /// Reloads collection.
    func forceRefill()

    /// Reloads collection with completion
    func forceRefill(completion: @escaping (() -> Void))

    // MARK: - Data source methods

    /// Adds a new cell generator.
    ///
    /// - Parameters:
    ///   - generator: The new cell generator.
    func addCellGenerator(_ generator: CellGeneratorType)

    /// Adds a new array of cell generators.
    ///
    /// - Parameters:
    ///   - generator: New cell generators.
    ///   - after: Generator after which generators should be added.
    func addCellGenerators(_ generators: [CellGeneratorType], after: CellGeneratorType)

    /// Adds a new cell generator.
    ///
    /// - Parameters:
    ///   - generator: New cell generator.
    ///   - after: Generator after which generator should be added.
    func addCellGenerator(_ generator: CellGeneratorType, after: CellGeneratorType)

    /// Adds a new array of cell generators.
    ///
    /// - Parameters:
    ///   - generator: Array of cell generators.
    func addCellGenerators(_ generators: [CellGeneratorType])

    /// Updates generators
    ///
    /// - Parameter generators: generators to update
    func update(generators: [CellGeneratorType])

    /// Removes all cell generators.
    func clearCellGenerators()

}
