//
//  FoldableCellGenerator.swift
//  ReactiveDataDisplayManager
//
//  Created by korshunov on 23.06.2023.
//

import UIKit

open class FoldableCellGenerator<Cell: UITableViewCell & ConfigurableItem & FoldableStateHolder>: BaseCellGenerator<Cell>, FoldableItem {

    // MARK: - FoldableItem

    open var animation: TableFoldablePlugin.AnimationGroup = (.left, .top)
    open var didFoldEvent = BaseEvent<Bool>()
    open var isExpanded = false
    open var childGenerators: [TableCellGenerator] = []

    // MARK: - BaseCellGenerator

    open override func configure(cell: Cell, with model: Cell.Model) {
        super.configure(cell: cell, with: model)

        cell.setExpanded(isExpanded)

        didFoldEvent.addListner(with: "rddm.foldable-on-dequeue") { [weak cell] isExpanded in
            cell?.setExpanded(isExpanded)
        }
    }

}
