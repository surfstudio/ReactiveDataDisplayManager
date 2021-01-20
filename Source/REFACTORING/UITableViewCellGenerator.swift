//
//  UITableViewCellGenerator.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 20.01.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

open class UITableViewCellGenerator<Cell: UITableViewCell>: CellGenerator, TableCellGenerator {

    public typealias Collection = UITableView

    // MARK: - Private Properties

    private let registerType: CellRegisterType

    // MARK: - Initialization

    public init(registerType: CellRegisterType = .nib) {
        self.registerType = registerType
    }

    public func generate(tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? Cell else {
            return UITableViewCell()
        }
        return cell
    }

    public func registerCell(in tableView: UITableView) {
        switch registerType {
        case .nib:
            tableView.registerNib(identifier)
        case .class:
            tableView.register(Cell.self, forCellReuseIdentifier: identifier)
        }
    }

    public var identifier: String {
        String(describing: Cell.self)
    }

    public var cellHeight: CGFloat {
        UITableView.automaticDimension
    }
    
    public var estimatedCellHeight: CGFloat? {
        nil
    }
}
