//
//  TableGeneratorsProvider.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 12.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

open class TableGeneratorsProvider: GeneratorsProvider {

    public typealias GeneratorType = TableCellGenerator
    public typealias HeaderGeneratorType = TableHeaderGenerator
    public typealias FooterGeneratorType = TableFooterGenerator

    open var sections: [SectionType<TableCellGenerator, TableHeaderGenerator, TableFooterGenerator>] = []

    func addTableGenerators(with generators: [TableCellGenerator], choice section: СhoiceTableSection) {
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

    func addNewSection(section: SectionType<TableCellGenerator, TableHeaderGenerator, TableFooterGenerator>) {
        sections.append(section)
    }

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

    func addHeader(header: TableHeaderGenerator) {
        addTableGenerators(with: [], choice: .newSection(header: header, footer: nil))
    }

    func addFooter(footer: TableFooterGenerator) {
        let index = sections.count - 1
        sections[index <= 0 ? 0 : index].footer = footer
    }

}
