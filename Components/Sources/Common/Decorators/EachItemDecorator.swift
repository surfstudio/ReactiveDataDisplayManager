//
//  EachItemDecorator.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 22.05.2023.
//

import ReactiveDataDisplayManager

final class EachItemDecorator: Decorator {

    func insert(decoration: Decoration,
                to items: [IdentifiableItem],
                at anchor: DecorationAnchor) -> [IdentifiableItem] {
        items.reduce([IdentifiableItem](), { (result, item) in
            guard let itemId = item.id else {
                return result
            }
            let decorationItem = decoration.provider.provideDecoration(with: itemId)
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
