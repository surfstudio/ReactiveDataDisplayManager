//
//  FirstItemDecorator.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 22.05.2023.
//

import ReactiveDataDisplayManager

final class FirstItemDecorator: Decorator {

    func insert(decoration: any DecorationProvider,
                to items: [IdOwner],
                at anchor: DecorationAnchor) -> [IdOwner] {
        guard let firstItem = items.first else {
            return items
        }

        var result = items

        let decorationItem = decoration.provideDecoration(with: firstItem.id)

        switch anchor {
        case .start:
            result.insert(decorationItem, at: 0)
        case .end:
            result.insert(decorationItem, at: 2)
        }

        return result
    }

}
