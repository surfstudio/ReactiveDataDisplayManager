//
//  BaseCellGenerator.swift
//  ReactiveDataDisplayManager
//
//  Created by Mikhail Monakov on 15/01/2019.
//  Copyright © 2020 Александр Кравченков. All rights reserved.
//

import UIKit

public typealias SelectableTableCellGenerator = TableCellGenerator & SelectableItem

/// Class for generating reusable Configurable UITableViewCell
open class BaseCellGenerator<Cell: ConfigurableItem>: SelectableTableCellGenerator where Cell: UITableViewCell {

    // MARK: - Public properties

    public var isNeedDeselect = true
    public var didSelectEvent = EmptyEvent()
    public var didDeselectEvent = EmptyEvent()
    public let model: Cell.Model

    // MARK: - Private Properties

    private let registerType: RegistrationType

    // MARK: - Initialization

    public init(with model: Cell.Model,
                registerType: RegistrationType = .nib) {
        self.model = model
        self.registerType = registerType
    }

    // MARK: - Open methods

    open func configure(cell: Cell, with model: Cell.Model) {
        cell.configure(with: model)
    }

    // MARK: - TableCellGenerator

    public var identifier: String {
        return String(describing: Cell.self)
    }

    public func generate(tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? Cell else {
            return UITableViewCell()
        }
        configure(cell: cell, with: model)
        return cell
    }

    public func registerCell(in tableView: UITableView) {
        switch registerType {
        case .nib:
            tableView.registerNib(identifier, bundle: Cell.bundle())
        case .class:
            tableView.register(Cell.self, forCellReuseIdentifier: identifier)
        }
    }

    open var cellHeight: CGFloat {
        UITableView.automaticDimension
    }

    open var estimatedCellHeight: CGFloat? {
        nil
    }

}

// MARK: - Decorations

public extension BaseCellGenerator {

    /// - Parameter isNeedDeselect: defines if cell should be deselected after selection
    func isNeedDeselect(_ isNeedDeselect: Bool) -> Self {
        self.isNeedDeselect = isNeedDeselect
        return self
    }

    /// - Parameter closure: closure that will be called when cell is selected
    func didSelectEvent(_ closure: @escaping () -> Void) -> Self {
        self.didSelectEvent.addListner(closure)
        return self
    }

    /// - Parameter closure: closure that will be called when cell is deselected in multiple selection mode
    func didDeselectEvent(_ closure: @escaping () -> Void) -> Self {
        self.didDeselectEvent.addListner(closure)
        return self
    }

}

// MARK: - Transformations

public extension BaseCellGenerator where Cell: FoldableStateHolder {

    /// Creates FoldableCellGenerator with predefined children
    /// - Parameter children: array of children
    func asFoldable(_ children: [TableCellGenerator]) -> FoldableCellGenerator<Cell> {
        return .init(with: model,
                     registerType: registerType)
            .children(children)
    }

    /// Creates FoldableCellGenerator with children generated by resultBuilder
    /// - Parameter content: resultBuilder based closure that returns array of children
    func asFoldable(@GeneratorsBuilder<TableCellGenerator>_ content: @escaping (TableContext.Type) -> [TableCellGenerator]) -> FoldableCellGenerator<Cell> {
        return .init(with: model,
                     registerType: registerType)
            .children(content)
    }

}

public extension BaseCellGenerator where Cell.Model: Equatable {

    /// Creates DiffableCellGenerator with constant but unique Id
    ///  - Parameter uniqueId: uniqueId to identify cell
    func asDiffable(uniqueId: AnyHashable) -> DiffableCellGenerator<Cell> {
        .init(uniqueId: uniqueId,
              with: model,
              registerType: registerType)
    }

}

public extension BaseCellGenerator where Cell.Model: Equatable & IdOwner {

    /// Creates DiffableCellGenerator with uniqueId from model
    func asDiffable() -> DiffableCellGenerator<Cell> {
        .init(uniqueId: model.id,
              with: model,
              registerType: registerType)
    }

}
