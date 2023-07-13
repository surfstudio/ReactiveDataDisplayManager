//
//  FoldableCollectionCellGenerator.swift
//  ReactiveDataDisplayManager
//
//  Created by korshunov on 23.06.2023.
//

import UIKit

// swiftlint:disable line_length
/// A generator that can insert and remove child generators by tap
open class FoldableCollectionCellGenerator<Cell: UICollectionViewCell & ConfigurableItem & FoldableStateHolder>: BaseCollectionCellGenerator<Cell>, CollectionFoldableItem {
// swiftlint:enable line_length

    // MARK: - FoldableItem

    /// Event on changed `isExpanded` state
    open var didFoldEvent = BaseEvent<Bool>()

    /// Folded/unfolded state
    open var isExpanded = false

    /// Child generators which can be folded/unfolded
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
