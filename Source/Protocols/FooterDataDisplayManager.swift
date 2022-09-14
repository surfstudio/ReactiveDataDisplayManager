//
//  FooterDataDisplayManager.swift
//  ReactiveDataDisplayManager
//
//  Created by Dmitry Korolev on 05.04.2021.
//

import UIKit

/// Determinantes interface for interaction with any display manager.
/// It can hide implementation of UITableView or UICollection view or your custom control with any data source.
public protocol FooterDataDisplayManager: AnyObject {

    // MARK: - Associatedtypes

    associatedtype GeneratorType
    associatedtype FooterGeneratorType

    // MARK: - Data source methods

    /// Adds a new header generator.
    ///
    /// - Parameter generator: The new generator.
    func addSectionFooterGenerator(_ generator: FooterGeneratorType)

    func addCellGenerator(_ generator: GeneratorType, toFooter footer: FooterGeneratorType)

    func addCellGenerators(_ generators: [GeneratorType], toFooter footer: FooterGeneratorType)

    func removeAllGenerators(from footer: FooterGeneratorType)

}
