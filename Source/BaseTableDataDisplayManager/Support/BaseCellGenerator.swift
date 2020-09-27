//
//  BaseCellGenerator.swift
//  ReactiveDataDisplayManager
//
//  Created by Mikhail Monakov on 15/01/2019.
//  Copyright © 2020 Александр Кравченков. All rights reserved.
//

import UIKit

/// Class for generating reusable Configurable UITableViewCell
public class BaseCellGenerator<Cell: Configurable>: TableCellGenerator, SelectableItem where Cell: UITableViewCell {

    // MARK: - Public properties

    public var didSelectEvent = BaseEvent<Void>()
    public let model: Cell.Model

    // MARK: - Private Properties

    private let registerType: CellRegisterType

    // MARK: - Initialization

    public init(with model: Cell.Model,
                registerType: CellRegisterType = .nib) {
        self.model = model
        self.registerType = registerType
    }

    // MARK: - TableCellGenerator

    public var identifier: UITableViewCell.Type {
        return Cell.self
    }

    public func generate(tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier.nameOfClass, for: indexPath) as? Cell else {
            return UITableViewCell()
        }
        cell.configure(with: model)
        return cell
    }

    public func registerCell(in tableView: UITableView) {
        switch registerType {
        case .nib:
            tableView.registerNib(identifier)
        case .class:
            tableView.register(identifier, forCellReuseIdentifier: identifier.nameOfClass)
        }
    }

}
