//
//  BaseCellGenerator.swift
//  ReactiveDataDisplayManager
//
//  Created by Mikhail Monakov on 15/01/2019.
//  Copyright © 2019 Александр Кравченков. All rights reserved.
//

import Foundation

public class BaseCellGenerator<Cell: Configurable>: SelectableItem where Cell: UITableViewCell {

    // MARK: - Properties

    public var didSelectEvent = BaseEvent<Void>()

    // MARK: - Private properties

    private let model: Cell.Model
    private let registerClass: Bool

    // MARK: - Initialization

    public init(with model: Cell.Model, registerClass: Bool = false) {
        self.model = model
        self.registerClass = registerClass
    }

}

// MARK: - TableCellGenerator

extension BaseCellGenerator: TableCellGenerator {

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
        if registerClass {
            tableView.register(identifier, forCellReuseIdentifier: identifier.nameOfClass)
        } else {
            tableView.registerNib(identifier)
        }
    }

}
