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
    associatedtype HeaderGeneratorType

    // MARK: Support methods

    init(collection: CollectionType)

    /// Reloads collection.
    func forceRefill()

    // MARK: - Data source methods

    /// Adds the new header generator.
    ///
    /// - Parameter generator: The new generator.
    func addSectionHeaderGenerator(_ generator: HeaderGeneratorType)

    /// Adds the new cell generator.
    ///
    /// - Parameters:
    ///   - generator: The new cell generator.
    func addCellGenerator(_ generator: CellGeneratorType)

    /// Adds new generators for cells
    ///
    /// - Parameters:
    ///   - generators: New generators
    ///   - after: Generator after which you need to add a new generators
    func addCellGenerators(_ generators: [CellGeneratorType], after: CellGeneratorType?)

    /// Adds generator for cell.
    ///
    /// - Parameters:
    ///   - generator: New generator
    ///   - after: Generator after which you need to add a new one
    func addCellGenerator(_ generator: CellGeneratorType, after: CellGeneratorType?)

    /// Adds the new array of cell generators.
    ///
    /// - Parameters:
    ///   - generator: Array of cell generators.
    func addCellGenerators(_ generators: [CellGeneratorType])

    /// Removes all header generators.
    func clearHeaderGenerators()

    /// Removes all cell generators.
    func clearCellGenerators()
}
