//
//  CalculatableHeightCellGenerator.swift
//  ReactiveDataDisplayManager
//
//  Created by Alexander Filimonov on 03/03/2020.
//  Copyright © 2020 Александр Кравченков. All rights reserved.
//

import Foundation

/// Class for generating reusable Configurable UITableViewCell with calculated height
public class CalculatableHeightCellGenerator<Cell: CalculatableHeight>: TableCellGenerator, SelectableItem where Cell: UITableViewCell {

    // MARK: - Public properties

    public var didSelectEvent = BaseEvent<Void>()
    public let model: Cell.Model

    // MARK: - Private Properties

    private let cellWidth: CGFloat
    private let registerType: CellRegisterType

    // MARK: - Initialization

    public init(with model: Cell.Model,
                cellWidth: CGFloat = UIScreen.main.bounds.width,
                registerType: CellRegisterType = .nib) {
        self.model = model
        self.cellWidth = cellWidth
        self.registerType = registerType
    }

    // MARK: - TableCellGenerator

    public var identifier: UITableViewCell.Type {
        return Cell.self
    }

    public var cellHeight: CGFloat {
        return Cell.getHeight(forWidth: cellWidth, with: model)
    }

    public var estimatedCellHeight: CGFloat? {
        return Cell.getHeight(forWidth: cellWidth, with: model)
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
