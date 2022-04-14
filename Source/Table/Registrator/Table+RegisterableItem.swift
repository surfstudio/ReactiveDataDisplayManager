//
//  Table+RegisterableItem.swift
//  Pods
//
//  Created by Никита Коробейников on 14.04.2022.
//

import UIKit

public protocol TableCellRegisterableItem: RegisterableItem {

    /// Register cell in tableView
    ///
    /// - Parameter tableView: TableView, in which cell will be registered
    func registerCell(in tableView: UITableView)
}

public protocol TableHeaderRegisterableItem: RegisterableItem {

    /// Register cell in tableView
    ///
    /// - Parameter tableView: TableView, in which header will be registered
    func registerHeader(in tableView: UITableView)
}

public protocol TableFooterRegisterableItem: RegisterableItem {

    /// Register cell in tableView
    ///
    /// - Parameter tableView: TableView, in which footer will be registered
    func registerFooter(in tableView: UITableView)
}
