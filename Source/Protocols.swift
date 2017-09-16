//
//  Protocols.swift
//  SampleEventHandling
//
//  Created by Alexander Kravchenkov on 01.08.17.
//  Copyright © 2017 Alexander Kravchenkov. All rights reserved.
//

import Foundation
import UIKit

/// Protocol for work with cell.
public protocol TableDataDisplayManager: class {

    /// Add generator of header for section.
    func addSectionHeaderGenerator(_ generator: ViewGenerator)

    /// Add generator for cell.
    func addCellGenerator(_ generator: TableCellGenerator, needRegister: Bool)

    /// Set tableView for current manager
    func setTableView(_ tableView: UITableView)
}

/// Protocol that incapsulated build logics for current View
public protocol ViewGenerator: class {

    func generate() -> UIView
}

/// Protocol that incapsulated type of current cell
public protocol TableCellGenerator: class {

    /// Nib type, which create this generator
    var identifier: UITableViewCell.Type { get }

    /// Create cell.
    ///
    /// - Parameter tableView: TableView, which controlled cell grations
    /// - Return: New (may reused) cell.
    func generate(tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell
}

/// Builder for concreate type of UIView
public protocol ViewBuilder {

    associatedtype ViewType: UIView

    /// Выполняет конфигурирование ячейки.
    ///
    /// - Parameter view: UIView которое необходимо сконфигурировать.
    func build(view: ViewType)
}

/// Protocol for selectable item.
public protocol SelectableItem: class {

    var didSelectEvent: BaseEvent<Void> { get }

    var didSelected: Bool { get }

    /// A Boolean value that determines whether to perform a cell deselect.
    ///
    /// If the value of this property is **true** (the default), cells deselect
    /// immediately after tap. If you set it to **false**, they don't deselect.
    var isNeedDeselect: Bool { get }
}

extension SelectableItem {
    var isNeedDeselect: Bool {
        return true
    }
}
