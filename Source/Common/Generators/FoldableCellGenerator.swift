//
//  FoldableCellGenerator.swift
//  ReactiveDataDisplayManager
//
//  Created by korshunov on 23.06.2023.
//

import UIKit

/// A generator that can insert and remove child generators by tap
open class FoldableCellGenerator<Cell: ConfigurableItem & FoldableStateHolder>: BaseCellGenerator<Cell>, FoldableItem, FoldableStateToggling {

    // MARK: - Private

    private var tableAnimation: TableChildrenAnimationGroup = (.left, .top)
    private var tableChildren: [TableCellGenerator] = []

    private var collectionChildren: [CollectionCellGenerator] = []

    // MARK: - Public

    /// Event on changed `isExpanded` state
    public var didFoldEvent = Event<Bool>()

    /// Folded/unfolded state
    public var isExpanded = false

    // MARK: - BaseCellGenerator

    public override func configure(cell: Cell, with model: Cell.Model) {
        super.configure(cell: cell, with: model)

        cell.setExpanded(isExpanded)

        didFoldEvent.addListner(with: "rddm.foldable-on-dequeue") { [weak cell] isExpanded in
            cell?.setExpanded(isExpanded)
        }
    }

    // MARK: - FoldableStateToggling

    public func toggleEpanded() {
        isExpanded.toggle()
    }

}

// MARK: - TableChildrenHolder

extension FoldableCellGenerator: TableChildrenHolder where Cell: UITableViewCell {

    public var children: [TableCellGenerator] {
        get {
            tableChildren
        }
        set {
            tableChildren = newValue
        }
    }

    public var animation: TableChildrenAnimationGroup {
        get {
            tableAnimation
        }
        set {
            tableAnimation = newValue
        }
    }

}

// MARK: - CollectionChildrenHolder

extension FoldableCellGenerator: CollectionChildrenHolder where Cell: UICollectionViewCell {

    public var children: [CollectionCellGenerator] {
        get {
            collectionChildren
        }
        set {
            collectionChildren = newValue
        }
    }

}

// MARK: - Decorations

public extension FoldableCellGenerator {

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

}

public extension FoldableCellGenerator where Cell: UITableViewCell {

    /// - Parameter animation: animations for cells insertion and deletion
    func animation(_ animation: TableChildrenAnimationGroup) -> Self {
        self.animation = animation
        return self
    }

    /// - Parameter children: array of child generators
    func children(_ children: [TableCellGenerator]) -> Self {
        self.children = children
        return self
    }

    /// - Parameter content: resultBuilder based closure that returns an array of child generators
    func children(@GeneratorsBuilder<TableCellGenerator>_ content: @escaping TableContext.CellsBuilder) -> Self {
        self.children = content(TableContext.self)
        return self
    }

}

public extension FoldableCellGenerator where Cell: UICollectionViewCell {

    /// - Parameter children: array of child generators
    func children(_ children: [CollectionCellGenerator]) -> Self {
        self.children = children
        return self
    }

    /// - Parameter content: resultBuilder based closure that returns an array of child generators
    func children(@GeneratorsBuilder<CollectionCellGenerator>_ content: @escaping CollectionContext.CellsBuilder) -> Self {
        self.children = content(CollectionContext.self)
        return self
    }

}
