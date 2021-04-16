//
//  FooterDataDisplayManager.swift
//  ReactiveDataDisplayManager
//
//  Created by Dmitry Korolev on 05.04.2021.
//

import UIKit

/// Determinantes interface for interaction with any display manager.
/// It can hide implementation of UITableView or UICollection view or your custom control with any data source.
public protocol FooterDataDisplayManager: class {

    // MARK:- Associatedtypes

    associatedtype CellGeneratorType
    associatedtype FooterGeneratorType

    // MARK: - Data source methods

    /// Adds a new header generator.
    ///
    /// - Parameter generator: The new generator.
    func addSectionFooterGenerator(_ generator: FooterGeneratorType)

    func addCellGenerator(_ generator: CellGeneratorType, toFooter footer: FooterGeneratorType)

    func addCellGenerators(_ generators: [CellGeneratorType], toFooter footer: FooterGeneratorType)

    func removeAllGenerators(from header: FooterGeneratorType)

    /// Removes all header generators.
    func clearFooterGenerators()
}
