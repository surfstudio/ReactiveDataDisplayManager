//
//  NonEmptyDecorator.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 22.05.2023.
//

import ReactiveDataDisplayManager

/// Decorator which designed to decorate only **non empty** arrays of items.
/// Alternative to `guard` in each implmentation of decorator.
final class NonEmptyDecorator: Decorator {

    private let decorator: Decorator

    init(decorator: Decorator) {
        self.decorator = decorator
    }

    func insert(decoration: Decoration,
                to items: [IdOwner],
                at anchor: DecorationAnchor) -> [IdOwner] {
        guard !items.isEmpty else {
            return items
        }
        return items
    }

}
