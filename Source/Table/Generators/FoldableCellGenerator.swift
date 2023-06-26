//
//  FoldableCellGenerator.swift
//  ReactiveDataDisplayManager
//
//  Created by korshunov on 23.06.2023.
//

import UIKit

/// A generator that can insert and remove child generators by tap
open class FoldableCellGenerator<Cell: UITableViewCell & ConfigurableItem & FoldableStateHolder>: BaseCellGenerator<Cell>, FoldableItem {

    // MARK: - FoldableItem

    /// Animations for cells insertion and deletion
    open var animation: TableFoldablePlugin.AnimationGroup = (.left, .top)

    /// Event on changed `isExpanded` state
    open var didFoldEvent = BaseEvent<Bool>()

    /// Folded/unfolded state
    open var isExpanded = false

    /// Child generators which can be folded/unfolded
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
