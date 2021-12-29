//
//  TableSectionsProvider.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 12.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

open class TableSectionsProvider: SectionsProvider {

    public typealias GeneratorType = TableCellGenerator
    public typealias HeaderGeneratorType = TableHeaderGenerator
    public typealias FooterGeneratorType = TableFooterGenerator

    open var sections: [Section<TableCellGenerator, TableHeaderGenerator, TableFooterGenerator>] = []

    /// Adds generators
    ///
    /// - Parameters:
    ///  - generators: - generators array
    ///  - section: - enum CollectionSectionСhoice (allows you to choose which section to add generators to)
    func addTableGenerators(with generators: [TableCellGenerator], choice section: TableSectionСhoice) {
        switch section {
        case .newSection(let header, let footer):
            self.addGeneratorsInNewSection(generators: generators, for: header, footer: footer)
        case .byIndex(let sectionIndex):
            self.addGeneratorsInSection(by: sectionIndex, generators: generators)
        case .lastSection:
            self.sections.isEmpty || sections.count <= 0 ?
            self.addTableGenerators(with: generators, choice: .newSection()) :
            self.addGeneratorsInLastSection(generators: generators)
        }
    }

    /// Adds a new section with empty generator array and empty footer
    func addHeader(header: TableHeaderGenerator) {
        addTableGenerators(with: [], choice: .newSection(header: header, footer: nil))
    }

    /// Replaces the empty footer of the last section
    func addFooter(footer: TableFooterGenerator) {
        let index = sections.count - 1
        sections[index <= 0 ? 0 : index].footer = footer
    }

}

// MARK: - Private Methods

private extension TableSectionsProvider {

    func addGeneratorsInLastSection(generators: [TableCellGenerator]) {
        let index = sections.count - 1
        sections[index].generators.append(contentsOf: generators)
    }

    func addGeneratorsInNewSection(generators: [TableCellGenerator],
                                   for header: TableHeaderGenerator? = nil,
                                   footer: TableFooterGenerator? = nil) {
        sections.append(.init(generators: generators,
                              header: header ?? EmptyTableHeaderGenerator(),
                              footer: footer ?? EmptyTableFooterGenerator()))
    }

    func addGeneratorsInSection(by index: Int, generators: [TableCellGenerator]) {
        sections[index <= 0 ? 0 : index].generators.append(contentsOf: generators)
    }

}
