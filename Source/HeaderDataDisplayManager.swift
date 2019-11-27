//
//  HeaderDataDisplayManager.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Dryakhlykh on 14.10.2019.
//  Copyright © 2019 Александр Кравченков. All rights reserved.
//

import Foundation

/// Determinantes interface for interaction with any display manager.
/// It can hide implementation of UITableView or UICollection view or your custom control with any data source.
public protocol HeaderDataDisplayManager: class {

    // MARK:- Associatedtypes

    associatedtype CellGeneratorType
    associatedtype HeaderGeneratorType

    // MARK: - Data source methods

    /// Adds a new header generator.
    ///
    /// - Parameter generator: The new generator.
    func addSectionHeaderGenerator(_ generator: HeaderGeneratorType)

    func addCellGenerator(_ generator: CellGeneratorType, toHeader header: HeaderGeneratorType)

    func addCellGenerators(_ generators: [CellGeneratorType], toHeader header: HeaderGeneratorType)

    func removeAllGenerators(from header: HeaderGeneratorType)

    /// Removes all header generators.
    func clearHeaderGenerators()
}
