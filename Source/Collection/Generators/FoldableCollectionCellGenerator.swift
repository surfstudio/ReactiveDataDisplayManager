//
//  FoldableCollectionCellGenerator.swift
//  ReactiveDataDisplayManager
//
//  Created by korshunov on 23.06.2023.
//

import UIKit

// swiftlint:disable:next line_length
open class FoldableCollectionCellGenerator<Cell: UICollectionViewCell & ConfigurableItem & FoldableStateHolder>: BaseCollectionCellGenerator<Cell>, CollectionFoldableItem {

    // MARK: - FoldableItem

    open var didFoldEvent = BaseEvent<Bool>()
    open var isExpanded = false
    open var childGenerators: [CollectionCellGenerator] = []

    // MARK: - BaseCollectionCellGenerator

    open override func configure(cell: Cell, with model: Cell.Model) {
        super.configure(cell: cell, with: model)

        cell.setExpanded(isExpanded)

        didFoldEvent.addListner(with: "rddm.foldable-on-dequeue") { [weak cell] isExpanded in
            cell?.setExpanded(isExpanded)
        }
    }

}
