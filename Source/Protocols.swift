//
//  Protocols.swift
//  SampleEventHandling
//
//  Created by Alexander Kravchenkov on 01.08.17.
//  Copyright © 2017 Alexander Kravchenkov. All rights reserved.
//

import Foundation
import UIKit

/// Protocol for work with cells and views adding.
public protocol TableDataDisplayManager: class {

    /// This method is used to add a new header to section generator.
    ///
    /// - Parameter generator: New view generator.
    func addSectionHeaderGenerator(_ generator: ViewGenerator)

    /// This method is used to add a new cell generator.
    ///
    /// - Parameters:
    ///   - generator: New cell generator.
    ///   - needRegister: Pass **true** if needed to register generator nib.
    func addCellGenerator(_ generator: TableCellGenerator, needRegister: Bool)

    /// This method is used to set UITableView to current adapter.
    ///
    /// - Parameter tableView: New UITableView.
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

    /// This method is used to create cell.
    ///
    /// - Parameter tableView: UITableView which contains cells.
    /// - Return: New (may reused) cell.
    func generate(tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell
}

/// Builder for concreate type of UIView
public protocol ViewBuilder {

    associatedtype ViewType: UIView

    /// This method is used to configure cell.
    ///
    /// - Parameter view: UIView that should be configured.
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
