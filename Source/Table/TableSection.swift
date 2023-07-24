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

}
