//
//  CollectionSection.swift
//  ReactiveDataDisplayManager
//
//  Created by porohov on 29.09.2022.
//

// MARK: - Global Typealias

public typealias CollectionSection = Section<
    CollectionCellGenerator,
    CollectionHeaderGenerator,
    CollectionFooterGenerator
>

// MARK: - Alternative initialization with empty footer

public extension CollectionSection {

    init(generators: [CollectionCellGenerator], header: CollectionHeaderGenerator) {
        self.init(generators: generators, header: header, footer: EmptyCollectionFooterGenerator())
    }

    static func create(header: HeaderGeneratorType,
                       footer: FooterGeneratorType,
                       @GeneratorsBuilder<GeneratorType> generators: CollectionContext.CellsBuilder) -> Self {
        Self(generators: generators(CollectionContext.self), header: header, footer: footer)
    }

}
