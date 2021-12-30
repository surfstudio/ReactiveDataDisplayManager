//
//  BaseNonReusableCellGenerator.swift
//  ReactiveDataDisplayManager
//
//  Created by Alexander Filimonov on 02/03/2020.
//  Copyright © 2020 Александр Кравченков. All rights reserved.
//

import UIKit

/// Class for generating *non-reusable* configurable **UITableViewCell**
///
/// Term *non-reusable* means that we are creating cell manually with constructor type defined in **ConstractableItem**.
/// In other words this generator will not use `tableView.deqeueReusableCell`.
///  - Warning: Do not use this generators in tables with many cells of same type. Because you may catch perfomance issues.
open class BaseNonReusableCellGenerator<Cell: ConfigurableItem & ConstractableItem>: SelectableTableCellGenerator where Cell: UITableViewCell {

    // MARK: - Public Properties

    public var isNeedDeselect = true
    public var didSelectEvent = BaseEvent<Void>()
    public var didDeselectEvent = BaseEvent<Void>()

    // MARK: - Properties

    private(set) public var model: Cell.Model

    private(set) public lazy var cell: Cell? = {
        switch Cell.constructionType {
        case .xib:
            return Cell.fromXib(bundle: Cell.bundle())
        case .manual:
            return Cell(frame: .zero)
        }
    }()

    // MARK: - Initialization

    public init(with model: Cell.Model) {
        self.model = model
    }

    // MARK: - Open Methods

    open func configure(cell: Cell, with model: Cell.Model) {
        cell.configure(with: model)
    }

    // MARK: - Public Methods

    public func update(model: Cell.Model) {
        self.model = model
        guard let cell = cell else {
            return
        }
        configure(cell: cell, with: model)
    }

    // MARK: - TableCellGenerator

    public var identifier: String {
        return String(describing: Cell.self)
    }

    public func generate(tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = cell else {
            return UITableViewCell()
        }
        configure(cell: cell, with: model)
        return cell
    }

    public func registerCell(in tableView: UITableView) {
        // We can leave this empty because we are not using reuse in this generator type
    }

}
