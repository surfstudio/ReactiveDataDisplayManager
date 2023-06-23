//
//  FoldableCollectionCellGenerator.swift
//  ReactiveDataDisplayManager
//
//  Created by korshunov on 23.06.2023.
//

import UIKit

open class FoldableCollectionCellGenerator<Cell: UICollectionViewCell & ConfigurableItem & FoldableStateHolder>: BaseCollectionCellGenerator<Cell>, CollectionFoldableItem {

    // MARK: - FoldableItem

    public var didFoldEvent = BaseEvent<Bool>()
    public var isExpanded = false {
        didSet {
            onStateChanged?(isExpanded)
        }
    }
    public var childGenerators: [CollectionCellGenerator] = []

    // MARK: - Private

    private var onStateChanged: ((Bool) -> Void)?

    // MARK: - BaseCollectionCellGenerator

    open override func configure(cell: Cell, with model: Cell.Model) {
        super.configure(cell: cell, with: model)
        
        cell.setExpanded(isExpanded)

        onStateChanged = { [weak cell] isExpanded in
            cell?.setExpanded(isExpanded)
        }
    }

}
