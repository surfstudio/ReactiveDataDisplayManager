//
//  FirstItemDecorator.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 22.05.2023.
//

import ReactiveDataDisplayManager

final class FirstItemDecorator: Decorator {

    func insert(decoration: Decoration,
                to items: [IdentifiableItem],
                at anchor: DecorationAnchor) -> [IdentifiableItem] {
        guard let firstItem = items.first, let firstItemId = firstItem.id else {
            return items
        }

        var result = items

        let decorationItem = decoration.provider.provideDecoration(with: firstItemId)

        switch anchor {
        case .start:
            result.insert(decorationItem, at: 0)
        case .end:
            result.insert(decorationItem, at: 2)
        }

        return result
    }

}
