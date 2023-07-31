//
//  TableSection.swift
//  ReactiveDataDisplayManager
//
//  Created by porohov on 29.09.2022.
//

// MARK: - Global Typealias

public typealias TableSection = Section<
    TableCellGenerator,
    TableHeaderGenerator,
    TableFooterGenerator
>

// MARK: - Alternative initialization with empty footer

public extension TableSection {

    init(generators: [TableCellGenerator], header: TableHeaderGenerator) {
        self.init(generators: generators, header: header, footer: EmptyTableFooterGenerator())
    }

    static func create(header: HeaderGeneratorType,
                       footer: FooterGeneratorType,
                       @GeneratorsBuilder<GeneratorType> generators: TableContext.CellsBuilder) -> Self {
        Self(generators: generators(TableContext.self), header: header, footer: footer)
    }

}
