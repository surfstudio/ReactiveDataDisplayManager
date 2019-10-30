//
//  DataDisplayManager.swift
//  ReactiveDataDisplayManager
//
//  Created by Alexander Kravchenkov on 09.02.2018.
//  Copyright © 2018 Александр Кравченков. All rights reserved.
//

import Foundation

/// Determinantes interface for interaction with any display manager.
/// It can hide implementation of UITableView or UICollection view or your custom control with any data source.
public protocol DataDisplayManager: class {

    // MARK:- Associatedtypes

    associatedtype CollectionType
    associatedtype CellGeneratorType

    // MARK: Support methods

    init(collection: CollectionType)

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
