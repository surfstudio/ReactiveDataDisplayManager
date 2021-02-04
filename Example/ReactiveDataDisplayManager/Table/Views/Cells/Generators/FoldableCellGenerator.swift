//
//  FoldableCellGenerator.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 01.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import ReactiveDataDisplayManager

final class FoldableCellGenerator: SelectableItem, TableFoldableItem {

    // MARK: - SelectableItem

    var didSelectEvent = BaseEvent<Void>()
    var isNeedDeselect = true

    // MARK: - FoldableItem

    var didFoldEvent = BaseEvent<Bool>()
    var isExpanded = false
    var childGenerators: [TableCellGenerator] = []

}

// MARK: - TableCellGenerator

extension FoldableCellGenerator: TableCellGenerator {

    var identifier: String {
        return String(describing: FoldableTableViewCell.self)
    }

}

// MARK: - ViewBuilder

extension FoldableCellGenerator: ViewBuilder {

    func build(view: FoldableTableViewCell) {
        view.fill(expanded: isExpanded)

        didFoldEvent.addListner { isExpanded in
            view.configure(expanded: isExpanded)
        }
    }

}
