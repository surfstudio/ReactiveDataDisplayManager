//
//  GeneratorsProvider.swift
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

// MARK: - Deprecated

@available(*, deprecated, message: "Please use `sections` instead.")
public extension SectionsProvider {

    /// Deprecated, use **sections**.
    ///
    /// The setter does not have full functionality
    var generators: [[GeneratorType]] {
        get { getOldSections().generators }
        set { addGenerator(generators: newValue) }
    }

    /// Returns the model of the old section view
    ///
    /// **Return old components:**
    ///  - generators: [[GeneratorType]]
    ///  - header: [HeaderGeneratorType]
    ///  - footer: [FooterGeneratorType]
    ///
    func getOldSections() -> OldSection<GeneratorType, HeaderGeneratorType, FooterGeneratorType> {
        var generators = [[GeneratorType]]()
        var headers = [HeaderGeneratorType]()
        var footers = [FooterGeneratorType]()
        for section in sections {
            headers.append(section.header)
            footers.append(section.footer)
            generators.append(section.generators)
        }
        return .init(generators: generators, headers: headers, footers: footers)
    }

}

// MARK: - Private

private extension SectionsProvider {

    func addGenerator(generators: [[GeneratorType]]) {
        generators.enumerated().forEach { index, generators in
            var section = sections[safe: index]
            section?.generators = generators
        }
    }

}
