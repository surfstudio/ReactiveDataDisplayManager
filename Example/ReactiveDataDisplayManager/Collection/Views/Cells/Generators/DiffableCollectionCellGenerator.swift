//
//  DiffableCollectionCellGenerator.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Никита Коробейников on 16.03.2021.
//

import ReactiveDataDisplayManager

final class DiffableCollectionCellGenerator: BaseCollectionCellGenerator<TitleCollectionListCell>, DiffableItemSource {

    private let uuid = UUID().uuidString

    var diffableItem: DiffableItem {
        DiffableItem(id: uuid, state: .init(model))
    }

}
