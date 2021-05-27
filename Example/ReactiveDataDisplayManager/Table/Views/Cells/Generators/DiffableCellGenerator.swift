//
//  DiffableCellGenerator.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 04.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import ReactiveDataDisplayManager

final class DiffableCellGenerator: BaseCellGenerator<TitleTableViewCell>, DiffableItemSource {

    private let uuid = UUID().uuidString

    var item: DiffableItem {
        DiffableItem(id: uuid, state: .init(model))
    }

}
