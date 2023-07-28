//
//  FoldableCellGenerator.swift
//  ReactiveDataDisplayManager
//
//  Created by korshunov on 23.06.2023.
//

import UIKit

/// A generator that can insert and remove child generators by tap
open class FoldableCellGenerator<Cell: ConfigurableItem & FoldableStateHolder>: BaseCellGenerator<Cell>, FoldableItem {

    // MARK: - FoldableItem

    /// Animations for cells insertion and deletion
    open var animation: TableFoldablePlugin.AnimationGroup = (.left, .top)

    /// Event on changed `isExpanded` state
    open var didFoldEvent = Event<Bool>()

    /// Folded/unfolded state
    open var isExpanded = false

    /// Child generators which can be folded/unfolded
    open var children: [TableCellGenerator] = []

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

public extension FoldableCellGenerator {

    /// - Parameter animation: animations for cells insertion and deletion
    func animation(_ animation: TableFoldablePlugin.AnimationGroup) -> Self {
        self.animation = animation
        return self
    }

    /// - Parameter isExpanded: folded/unfolded state
    func isExpanded(_ isExpanded: Bool) -> Self {
        self.isExpanded = isExpanded
        return self
    }

    /// - Parameter closure: handler closure for folded/unfolded events
    func didFoldEvent(_ closure: @escaping (Bool) -> Void) -> Self {
        self.didFoldEvent.addListner(closure)
        return self
    }

    /// - Parameter children: array of child generators
    func children(_ children: [TableCellGenerator]) -> Self {
        self.children = children
        return self
    }

    /// - Parameter content: resultBuilder based closure that returns an array of child generators
    func children(@GeneratorsBuilder<TableCellGenerator>_ content: @escaping (TableContext.Type) -> [TableCellGenerator]) -> Self {
        self.children = content(TableContext.self)
        return self
    }

}
