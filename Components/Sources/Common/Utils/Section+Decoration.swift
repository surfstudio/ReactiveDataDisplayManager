//
//  Section+Decoration.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 22.05.2023.
//

import ReactiveDataDisplayManager

public extension Section where GeneratorType: TableCellGenerator, GeneratorType: DiffableItemSource {

    func decorate(with decoration: Decoration, at anchor: DecorationAnchor, and rule: DecorationRule) -> Section<any TableCellGenerator & DiffableItemSource, HeaderGeneratorType, FooterGeneratorType> {
        let decorator = rule.decorator

        let decoratedItems = decorator.insert(decoration: decoration.tableProvider,
                                              to: generators,
                                              at: anchor)
            .compactMap { AnyIdentifiableTableCellGenerator(identifiable: $0) }

        return .init(generators: decoratedItems,
                     header: header,
                     footer: footer)
    }

}

public extension Section where GeneratorType: CollectionCellGenerator, GeneratorType: DiffableItemSource {

    func decorate(with decoration: Decoration, at anchor: DecorationAnchor, and rule: DecorationRule) -> Self {
        let decorator = rule.decorator

        let decoratedItems = decorator.insert(decoration: decoration.collectionProvider,
                                              to: generators,
                                              at: anchor)
            .compactMap { $0 as? GeneratorType }

        return Section(generators: decoratedItems,
                       header: header,
                       footer: footer)
    }

}


