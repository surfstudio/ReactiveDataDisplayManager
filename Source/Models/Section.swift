//
//  Section.swift
//  Pods
//
//  Created by porohov on 12.12.2021.
//

import Foundation

/// Generic old section for tables and collections
public struct OldSection<GeneratorType, HeaderGeneratorType, FooterGeneratorType> {
    public var generators: [[GeneratorType]]
    public var headers: [HeaderGeneratorType]
    public var footers: [FooterGeneratorType]

    public init(generators: [[GeneratorType]], headers: [HeaderGeneratorType], footers: [FooterGeneratorType]) {
        self.generators = generators
        self.headers = headers
        self.footers = footers
    }
}

/// Generic section for tables and collections
public struct Section<GeneratorType, HeaderGeneratorType, FooterGeneratorType> {
    public var generators: [GeneratorType]
    public var header: HeaderGeneratorType
    public var footer: FooterGeneratorType

    public init(generators: [GeneratorType], header: HeaderGeneratorType, footer: FooterGeneratorType) {
        self.generators = generators
        self.header = header
        self.footer = footer
    }
}

public extension Section {

    /// Returns DiffableSection
    ///
    /// The returned components can be used in Diffable Data Source
    func asDiffableItemSource() -> DiffableSection? {
        let header = header as? DiffableItemSource
        let generators = (generators as? [DiffableItemSource] ?? []).compactMap { $0.diffableItem }
        let footer = self.footer as? DiffableItemSource

        return .init(header: header, footer: footer, generators: generators)
    }

}

/// DiffableSection - Used for Diffable data source
///
/// Consists of:
///
///     header: DiffableItemSource?
///     footer: DiffableItemSource?
///     generators: [DiffableItem]
public struct DiffableSection {
    let header: DiffableItemSource?
    let footer: DiffableItemSource?
    let generators: [DiffableItem]
}
