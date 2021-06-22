//
//  TitleCollectionGenerator.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Ivan Smetanin on 28/01/2018.
//  Copyright © 2018 Alexander Kravchenkov. All rights reserved.
//

import ReactiveDataDisplayManager

final class TitleCollectionGenerator: BaseCollectionCellGenerator<TitleCollectionViewCell>, IndexTitleDisplaybleItem, DragAndDroppableItemSource {

    // MARK: - IndexTitleDisplayble

    var title: String
    var needIndexTitle: Bool
    var item: DragAndDroppableItem

    // MARK: - Initialization

    public init(model: String, needIndexTitle: Bool = false) {
        self.title = model
        self.needIndexTitle = needIndexTitle

        let id = model as NSString
        item = DragAndDroppableItem(identifier: id)

        super.init(with: model)
    }

}
