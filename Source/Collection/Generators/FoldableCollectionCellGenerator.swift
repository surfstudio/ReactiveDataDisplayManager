//
//  FoldableCollectionCellGenerator.swift
//  ReactiveDataDisplayManager
//
//  Created by korshunov on 23.06.2023.
//

import UIKit

// swiftlint:disable line_length
/// A generator that can insert and remove child generators by tap
open class FoldableCollectionCellGenerator<Cell: UICollectionViewCell & ConfigurableItem & FoldableStateHolder>: BaseCellGenerator<Cell>, CollectionFoldableItem {
// swiftlint:enable line_length

    // MARK: - FoldableItem

    /// Event on changed `isExpanded` state
    open var didFoldEvent = Event<Bool>()

    /// Folded/unfolded state
    open var isExpanded = false

    /// Child generators which can be folded/unfolded
    open var children: [CollectionCellGenerator] = []

    // MARK: - BaseCellGenerator

    open override func configure(cell: Cell, with model: Cell.Model) {
        super.configure(cell: cell, with: model)

        cell.setExpanded(isExpanded)

        didFoldEvent.addListner(with: "rddm.foldable-on-dequeue") { [weak cell] isExpanded in
            cell?.setExpanded(isExpanded)
        }
    }

}

// MARK: - Decorations

public extension FoldableCollectionCellGenerator {

    /// - Parameter isExpanded: folded/unfolded state
    func isExpanded(_ isExpanded: Bool) -> Self {
        self.isExpanded = isExpanded
        return self
    }

    /// - Parameter closure: handler closure for expand/collapse events
    func didFoldEvent(_ closure: @escaping (Bool) -> Void) -> Self {
        self.didFoldEvent.addListner(closure)
        return self
    }

    /// - Parameter children: array of child generators
    func children(_ children: [CollectionCellGenerator]) -> Self {
        self.children = children
        return self
    }

    /// - Parameter content: resultBuilder based closure that returns an array of child generators
    func children(@GeneratorsBuilder<CollectionCellGenerator>_ content: @escaping (CollectionContext.Type) -> [CollectionCellGenerator]) -> Self {
        self.children = content(CollectionContext.self)
        return self
    }

}
