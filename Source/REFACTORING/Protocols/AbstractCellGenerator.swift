//
//  AbstractCellGenerator.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 20.01.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

public protocol CellGenerator: class {

    associatedtype Cell
    associatedtype Collection

    /// Creates a cell.
    ///
    /// - Parameter tableView: TableView, which controlled cell grations
    /// - Return: New (may reused) cell.
    func generate(tableView: Collection, for indexPath: IndexPath) -> Cell

    /// Register cell in tableView
    ///
    /// - Parameter in: TableView, in which cell will be registered
    func registerCell(in tableView: Collection)
}
