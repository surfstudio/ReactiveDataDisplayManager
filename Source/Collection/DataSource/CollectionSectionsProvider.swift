//
//  CollectionSectionsProvider.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 12.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

open class CollectionSectionsProvider: SectionsProvider {

    public typealias GeneratorType = CollectionCellGenerator
    public typealias HeaderGeneratorType = CollectionHeaderGenerator
    public typealias FooterGeneratorType = CollectionFooterGenerator

    /// An array of sections. Within each section One header, One footer, and an array of generators
    open var sections: [Section<CollectionCellGenerator, CollectionHeaderGenerator, CollectionFooterGenerator>] = []

    /// Adds generators
    ///
    /// - Parameters:
    ///  - generators: - generators array
    ///  - section: - enum CollectionSectionСhoice (allows you to choose which section to add generators to)
    func addCollectionGenerators(with generators: [CollectionCellGenerator], choice section: CollectionSectionСhoice) {
        switch section {
        case .newSection(let header, let footer):
            self.addGeneratorsInNewSection(generators: generators, for: header, footer: footer)
        case .byIndex(let sectionIndex):
            self.addGeneratorsInSection(by: sectionIndex, generators: generators)
        case .lastSection:
            self.sections.isEmpty || sections.count <= 0 ?
            self.addCollectionGenerators(with: generators, choice: .newSection()) :
            self.addGeneratorsInLastSection(generators: generators)
        }
    }

    /// Adds a new section with empty generator array and empty footer
    func addHeader(header: CollectionHeaderGenerator) {
        addCollectionGenerators(with: [], choice: .newSection(header: header, footer: nil))
    }

    /// Replaces the empty footer of the last section
    func addFooter(footer: CollectionFooterGenerator) {
        let index = sections.count - 1
        sections[index <= 0 ? 0 : index].footer = footer
    }

}

// MARK: - Private Methods

private extension CollectionSectionsProvider {

    func addGeneratorsInLastSection(generators: [CollectionCellGenerator]) {
        let index = sections.count - 1
        sections[index].generators.append(contentsOf: generators)
    }

    func addGeneratorsInNewSection(generators: [CollectionCellGenerator],
                                   for header: CollectionHeaderGenerator? = nil,
                                   footer: CollectionFooterGenerator? = nil) {
        sections.append(.init(generators: generators,
                              header: header ?? EmptyCollectionHeaderGenerator(),
                              footer: footer ?? EmptyCollectionFooterGenerator()))
    }

    func addGeneratorsInSection(by index: Int, generators: [CollectionCellGenerator]) {
        sections[index <= 0 ? 0 : index].generators.append(contentsOf: generators)
    }

}
