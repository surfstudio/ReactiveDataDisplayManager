//
//  BaseCellGenerator.swift
//  ReactiveDataDisplayManager
//
//  Created by Mikhail Monakov on 15/01/2019.
//  Copyright © 2019 Александр Кравченков. All rights reserved.
//

import Foundation

/// Protocol for UITableViewCell which is supposed to be used in BaseCellGenerator
public protocol Configurable where Self: UITableViewCell {

    associatedtype Model

    func configure(with model: Model)

}

public class BaseCellGenerator<Cell: Configurable>: SelectableItem {

    // MARK: - Properties

    public var didSelectEvent = BaseEvent<Void>()

    // MARK: - Private properties

    private let model: Cell.Model

    // MARK: - Initialization

    public init(with model: Cell.Model) {
        self.model = model
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
        tableView.registerNib(identifier)
    }

}
