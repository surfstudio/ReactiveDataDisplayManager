//
//  FoldableCellGenerator.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 01.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import ReactiveDataDisplayManager

class FoldableCellGenerator: BaseCellGenerator<FoldableTableViewCell>, FoldableItem {

    // MARK: - FoldableItem

    var animation: TableFoldablePlugin.AnimationGroup = (.left, .top)
    var didFoldEvent = BaseEvent<Bool>()
    var isExpanded = false
    var childGenerators: [TableCellGenerator] = []

    // MARK: - BaseCellGenerator

    override func configure(cell: FoldableTableViewCell, with model: FoldableTableViewCell.Model) {
        super.configure(cell: cell, with: model)

        didFoldEvent.addListner { isExpanded in
            cell.update(isExpanded: isExpanded)
        }
    }

}
