//
//  MovableCollectionCellGenerator.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 15.04.2021.
//

import Foundation
import ReactiveDataDisplayManager

final class MovableCollectionCellGenerator: BaseCellGenerator<TitleCollectionListCell>, MovableItem {

    // MARK: - Properties

    var id: AnyHashable?

    private var referencedWidth: CGFloat

    // MARK: - Initialization

    init(id: Int, model: String, referencedWidth: CGFloat) {
        self.id = id
        self.referencedWidth = referencedWidth
        super.init(with: model)
    }

}

extension MovableCollectionCellGenerator: SizableItem {

    func getSize() -> CGSize {
        .init(width: referencedWidth,
              height: TitleCollectionListCell.getHeight(forWidth: referencedWidth, with: model)
        )
    }

}
