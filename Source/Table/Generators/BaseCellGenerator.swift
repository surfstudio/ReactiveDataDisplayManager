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
    public var didSelectEvent = BaseEvent<Void>()
    public var didDeselectEvent = BaseEvent<Void>()
    public let model: Cell.Model

    // MARK: - Private Properties

    private let registerType: CellRegisterType

    // MARK: - Initialization

    public init(with model: Cell.Model,
                registerType: CellRegisterType = .nib) {
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
