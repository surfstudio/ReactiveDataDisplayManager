//
//  SectionsProvider.swift
//  ReactiveDataDisplayManager
//
//  Created by Konstantin Porokhov on 15.04.2021.
//

import Foundation

/// Universal section provider
public protocol SectionsProvider: AnyObject {
    associatedtype GeneratorType
    associatedtype HeaderGeneratorType
    associatedtype FooterGeneratorType

    /// Represents a section.
    ///
    /// Each section has one header, one footer and an array of cells (generators)
    var sections: [Section<GeneratorType, HeaderGeneratorType, FooterGeneratorType>] { get set }
}
