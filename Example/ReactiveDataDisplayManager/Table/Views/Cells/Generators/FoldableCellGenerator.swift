//
//  FoldableCellGenerator.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 01.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import ReactiveDataDisplayManager

final class FoldableCellGenerator: BaseCellGenerator<FoldableTableViewCell>, FoldableItem {

    // MARK: - FoldableItem

    var didFoldEvent = BaseEvent<Bool>()
    var isExpanded = false
    var childGenerators: [TableCellGenerator] = []

    // MARK: - ViewBuilder

    override func generate(tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        let view = super.generate(tableView: tableView, for: indexPath)

        didFoldEvent.addListner { isExpanded in
            (view as? FoldableTableViewCell)?.update(expanded: isExpanded)
        }

        return view
    }

}
