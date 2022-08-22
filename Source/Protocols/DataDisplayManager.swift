//
//  DataDisplayManager.swift
//  ReactiveDataDisplayManager
//
//  Created by Alexander Kravchenkov on 09.02.2018.
//  Copyright © 2018 Александр Кравченков. All rights reserved.
//

import UIKit

/// Determinantes interface for interaction with any display manager.
/// It can hide implementation of UITableView or UICollection view or your custom control with any data source.
public protocol DataDisplayManager: AnyObject {

    // MARK: - Associatedtypes

    associatedtype CollectionType
    associatedtype GeneratorType

    // swiftlint:disable implicitly_unwrapped_optional
    var view: CollectionType! { get }
    // swiftlint:enable implicitly_unwrapped_optional

    /// Reloads collection.
    func forceRefill()

    // MARK: - Data source methods

    /// Adds a new cell generator.
    ///
    /// - Parameters:
    ///   - generator: The new cell generator.
    func addCellGenerator(_ generator: GeneratorType)

    /// Adds a new array of cell generators.
    ///
    /// - Parameters:
    ///   - generator: New cell generators.
    ///   - after: Generator after which generators should be added.
    func addCellGenerators(_ generators: [GeneratorType], after: GeneratorType)

    /// Adds a new cell generator.
    ///
    /// - Parameters:
    ///   - generator: New cell generator.
    ///   - after: Generator after which generator should be added.
    func addCellGenerator(_ generator: GeneratorType, after: GeneratorType)

    /// Adds a new array of cell generators.
    ///
    /// - Parameters:
    ///   - generator: Array of cell generators.
    func addCellGenerators(_ generators: [GeneratorType])

    /// Updates generators
    ///
    /// - Parameter generators: generators to update
    func update(generators: [GeneratorType])

    /// Removes all cells generators and sections.
    func clearCellGenerators()

}

public extension DataDisplayManager {

    /// Reloads collection with completion
    func forceRefill(completion: @escaping (() -> Void)) {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            completion()
        }
        self.forceRefill()
        CATransaction.commit()
    }

}
