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

    public var didFoldEvent = BaseEvent<Bool>()

    public var isExpanded = false {
        didSet {
            onStateChanged?(isExpanded)
        }
    }

    open var childGenerators: [TableCellGenerator] = []

    // MARK: - Private

    private var onStateChanged: ((Bool) -> Void)?

    // MARK: - BaseCellGenerator

    open override func configure(cell: Cell, with model: Cell.Model) {
        super.configure(cell: cell, with: model)

        cell.setExpanded(isExpanded)

        onStateChanged = { [weak cell] isExpanded in
            cell?.setExpanded(isExpanded)
        }
    }

}
