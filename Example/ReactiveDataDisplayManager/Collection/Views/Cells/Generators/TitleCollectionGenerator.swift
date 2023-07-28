//
//  TitleCollectionGenerator.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Ivan Smetanin on 28/01/2018.
//  Copyright © 2018 Alexander Kravchenkov. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager

final class TitleCollectionGenerator: BaseCellGenerator<TitleCollectionViewCell>, IndexTitleDisplaybleItem {

    // MARK: - IndexTitleDisplayble

    var title: String
    var needIndexTitle: Bool
    var referencedWidth: CGFloat
    var id: AnyHashable?

    // MARK: - Private Properties

    private let dragAndDroppableItem: DragAndDroppableItem

    // MARK: - Initialization

    public init(model: String, referencedWidth: CGFloat, needIndexTitle: Bool = false) {
        self.title = model
        self.referencedWidth = referencedWidth
        self.needIndexTitle = needIndexTitle
        self.id = model

        let id = model as NSString
        dragAndDroppableItem = DragAndDroppableItem(identifier: id)

        super.init(with: model)
    }

}

// MARK: - DragAndDroppableItemSource

extension TitleCollectionGenerator: DragAndDroppableItemSource {

    var dropableItem: DragAndDroppableItem {
        return dragAndDroppableItem
    }

}

// MARK: - SizableItem

extension TitleCollectionGenerator: SizableItem {

    func getSize() -> CGSize {
        .init(width: referencedWidth,
              height: TitleCollectionViewCell.getHeight(forWidth: referencedWidth, with: title)
        )
    }

}
