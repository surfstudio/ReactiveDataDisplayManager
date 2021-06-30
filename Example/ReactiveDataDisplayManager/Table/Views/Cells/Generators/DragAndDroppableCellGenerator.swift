//
//  DragAndDroppableCellGenerator.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 18.02.2021.
//

import Foundation
import ReactiveDataDisplayManager

final class DragAndDroppableCellGenerator: BaseCellGenerator<TitleTableViewCell>, DragAndDroppableItemSource {

    // MARK: - Properties

    var item: DragAndDroppableItem

    // MARK: - Initialization

    public init(with model: String) {
        let id = model as NSString
        item = DragAndDroppableItem(identifier: id)

        super.init(with: model)
    }

}
