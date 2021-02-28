//
//  DragAndDroppableCollectionGenerator.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 18.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import ReactiveDataDisplayManager

class DragAndDroppableCollectionGenerator: BaseCollectionCellGenerator<ImageCollectionViewCell>, DragAndDroppableItem {

    var draggableIdentifier: NSItemProviderWriting

    init(with model: ImageCollectionViewCell.ViewModel) {
        draggableIdentifier = model.imageUrl as NSURL
        super.init(with: model)
    }

}
