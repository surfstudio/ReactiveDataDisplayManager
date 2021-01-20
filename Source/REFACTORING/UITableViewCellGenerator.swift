//
//  UITableViewCellGenerator.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 20.01.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

open class UITableViewCellGenerator<Cell: UITableViewCell>: CellGenerator {
    public typealias Cell = UITableViewCell
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
}

extension CellGenerator where Cell: UITableViewCell, Collection: UITableView {

    /// Nib type, which create this generator
    var identifier: String {
        String(describing: Cell.self)
    }

    /// Height for cell.
    ///
    /// Default implementation returns UITableView.automaticDimension
    var cellHeight: CGFloat {
        UITableView.automaticDimension
    }

    /// Estimated height for cell
    ///
    /// Default implementation returns nil
    var estimatedCellHeight: CGFloat? {
        nil
    }

}
