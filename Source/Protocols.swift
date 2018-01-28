//
//  Protocols.swift
//  ReactiveDataDisplayManager
//
//  Created by Alexander Kravchenkov on 01.08.17.
//  Copyright © 2017 Alexander Kravchenkov. All rights reserved.
//

import Foundation
import UIKit

public protocol DataDisplayManager: class {
    associatedtype CollectionType
    associatedtype CellGeneratorType
    associatedtype HeaderGeneratorType

    /// Sets collection to current data display manager.
    ///
    /// - Parameter collection: The collection that should be setted to data display manager.
    func set(collection: CollectionType)

    /// Adds the new header generator.
    ///
    /// - Parameter generator: The new generator.
    func addSectionHeaderGenerator(_ generator: HeaderGeneratorType)

    /// Removes all header generators.
    func clearHeaderGenerators()

    /// Adds the new cell generator.
    ///
    /// - Parameters:
    ///   - generator: The new cell generator.
    func addCellGenerator(_ generator: CellGeneratorType)

    /// Adds the new array of cell generators.
    ///
    /// - Parameters:
    ///   - generator: Array of cell generators.
    func addCellGenerators(_ generators: [CellGeneratorType])

    /// Removes all cell generators.
    func clearCellGenerators()

    /// Reloads collection.
    func didRefill()
}

public protocol TableHeaderGenerator: ViewGenerator {
    func height(_ tableView: UITableView, forSection section: Int) -> CGFloat
}

/// Protocol that incapsulated type of current cell
public protocol TableCellGenerator: class {

    /// Nib type, which create this generator
    var identifier: UITableViewCell.Type { get }

    /// Creates a cell.
    ///
    /// - Parameter tableView: TableView, which controlled cell grations
    /// - Return: New (may reused) cell.
    func generate(tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell
}


public protocol CollectionHeaderGenerator: ViewGenerator {
    func height(_ collectionView: UICollectionView, forSection section: Int) -> CGFloat
}

/// Protocol that incapsulated type of current cell
public protocol CollectionCellGenerator: class {

    /// Nib type, which create this generator
    var identifier: UICollectionViewCell.Type { get }

    /// Creates a cell.
    ///
    /// - Parameter tableView: TableView, which controlled cell grations
    /// - Return: New (may reused) cell.
    func generate(collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionViewCell
}

/// Protocol that incapsulated build logics for current View
public protocol ViewGenerator: class {
    func generate() -> UIView
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

public protocol DeletableGenerator {
    var eventDelete: BaseEmptyEvent { get }
}

extension SelectableItem {
    var isNeedDeselect: Bool {
        return true
    }
}

