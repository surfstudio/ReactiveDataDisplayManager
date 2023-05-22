//
//  Section+Decoration.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 22.05.2023.
//

import ReactiveDataDisplayManager

public extension Section where GeneratorType: IdentifiableItem {

    func decorateCells(with decoration: Decoration, at anchor: DecorationAnchor, and rule: DecorationRule) -> Section {
        let decorator = rule.decorator

        let decoratedItems = decorator.insert(decoration: decoration,
                                              to: generators,
                                              at: anchor)
            .compactMap { $0 as? GeneratorType }

        return Section(generators: decoratedItems,
                       header: header,
                       footer: footer)
    }
    

}


