//
//  FoldableCollectionCellGenerator.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Vadim Tikhonov on 11.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import ReactiveDataDisplayManager

final class FoldableCollectionCellGenerator: BaseCollectionCellGenerator<FoldableCollectionViewCell>, CollectionFoldableItem {

    // MARK: - FoldableItem

    var didFoldEvent = BaseEvent<Bool>()
    var isExpanded = false
    var childGenerators: [CollectionCellGenerator] = []

    // MARK: - BaseCollectionCellGenerator

    override func configure(cell: FoldableCollectionViewCell, with model: FoldableCollectionViewCell.Model) {
        super.configure(cell: cell, with: model)
        cell.update(isExpanded: isExpanded)

        didFoldEvent.addListner { isExpanded in
            cell.update(isExpanded: isExpanded)
        }
    }

}
