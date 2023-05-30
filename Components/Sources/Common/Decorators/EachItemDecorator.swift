//
//  EachItemDecorator.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 22.05.2023.
//

import ReactiveDataDisplayManager

final class EachItemDecorator: Decorator {

    func insert(decoration: any DecorationProvider,
                to items: [DiffableItemSource],
                at anchor: DecorationAnchor) -> [DiffableItemSource] {
        items.reduce([DiffableItemSource](), { (result, item) in
            let decorationItem = decoration.provideDecoration(with: item.diffableItem.id)
            var result = result
            switch anchor {
            case .start:
                result.append(decorationItem)
                result.append(item)
            case .end:
                result.append(item)
                result.append(decorationItem)
            }
            return result
        })
    }

}
