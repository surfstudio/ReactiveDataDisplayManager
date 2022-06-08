//
//  TitleCollectionGenerator.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Ivan Smetanin on 28/01/2018.
//  Copyright © 2018 Alexander Kravchenkov. All rights reserved.
//

import ReactiveDataDisplayManager

final class TitleCollectionGenerator: BaseCollectionCellGenerator<TitleCollectionViewCell>, IndexTitleDisplaybleItem {

    // MARK: - IndexTitleDisplayble

    var title: String
    var needIndexTitle: Bool
    var cell: TitleCollectionViewCell?

    // MARK: - Private Properties

    private let dragAndDroppableItem: DragAndDroppableItem

    // MARK: - Initialization

    public init(model: String, needIndexTitle: Bool = false) {
        self.title = model
        self.needIndexTitle = needIndexTitle

        let id = model as NSString
        dragAndDroppableItem = DragAndDroppableItem(identifier: id)

        super.init(with: model)
    }

    override func configure(cell: TitleCollectionViewCell, with model: String) {
        self.cell = cell
        super.configure(cell: cell, with: model)
    }

}

// MARK: - DragAndDroppableItemSource

extension TitleCollectionGenerator: DragAndDroppableItemSource {

    var dropableItem: DragAndDroppableItem {
        return dragAndDroppableItem
    }

}
