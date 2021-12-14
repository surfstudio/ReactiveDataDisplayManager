//
//  BaseNonReusableCellGenerator.swift
//  ReactiveDataDisplayManager
//
//  Created by Alexander Filimonov on 02/03/2020.
//  Copyright © 2020 Александр Кравченков. All rights reserved.
//

import UIKit

/// Class for generating non-reusable Configurable UITableViewCell
open class BaseNonReusableCellGenerator<Cell: ConfigurableItem>: SelectableTableCellGenerator where Cell: UITableViewCell {

    // MARK: - Public properties

    open var isNeedDeselect = true
    public var didSelectEvent = BaseEvent<Void>()
    public var didDeselectEvent = BaseEvent<Void>()
    private(set) public var model: Cell.Model
    private(set) public lazy var cell: Cell? = {
        return Cell.fromXib(bundle: Cell.bundle())
    }()

    // MARK: - Private Properties

    private let registerType: CellRegisterType

    // MARK: - Initialization

    public init(with model: Cell.Model,
                registerType: CellRegisterType = .nib) {
        self.model = model
        self.registerType = registerType
    }

    // MARK: - Public Methods

    public func update(model: Cell.Model) {
        self.model = model
        cell?.configure(with: model)
    }

    // MARK: - TableCellGenerator

    public var identifier: String {
        return String(describing: Cell.self)
    }

    public func generate(tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        cell?.configure(with: model)
        return cell ?? UITableViewCell()
    }

    public func registerCell(in tableView: UITableView) {
        switch registerType {
        case .nib:
            tableView.registerNib(identifier, bundle: Cell.bundle())
        case .class:
            tableView.register(Cell.self, forCellReuseIdentifier: identifier)
        }
    }

}
