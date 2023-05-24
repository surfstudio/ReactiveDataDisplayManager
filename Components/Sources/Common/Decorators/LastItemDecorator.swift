//
//  LastItemDecorator.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 22.05.2023.
//

import ReactiveDataDisplayManager

final class LastItemDecorator: Decorator {

    func insert(decoration: any DecorationProvider,
                to items: [DiffableItemSource],
                at anchor: DecorationAnchor) -> [DiffableItemSource] {

        guard let lastItem = items.last else {
            return items
        }

        var result = items

        let decorationItem = decoration.provideDecoration(with: lastItem.diffableItem.id)

        switch anchor {
        case .start:
            result.insert(decorationItem, at: items.count - 2)
        case .end:
            result.append(decorationItem)
        }

        return result
    }

}
