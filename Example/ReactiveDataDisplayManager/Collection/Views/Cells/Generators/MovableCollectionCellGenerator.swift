//
//  MovableCollectionCellGenerator.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 15.04.2021.
//

import Foundation
import ReactiveDataDisplayManager

final class MovableCollectionCellGenerator: BaseCollectionCellGenerator<TitleCollectionListCell>, MovableItem {

    // MARK: - Properties

    var id: AnyHashable?

    // MARK: - Initialization

    init(id: Int, model: String) {
        self.id = id
        super.init(with: model)
    }

}
