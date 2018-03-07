//
//  Protocols.swift
//  ReactiveDataDisplayManager
//
//  Created by Alexander Kravchenkov on 01.08.17.
//  Copyright © 2017 Alexander Kravchenkov. All rights reserved.
//

import Foundation
import UIKit

open class TableHeaderGenerator: ViewGenerator {

    public init() { }
    
    open func generate() -> UIView {
        preconditionFailure("\(#function) must be overriden in child")
    }

    open func height(_ tableView: UITableView, forSection section: Int) -> CGFloat {
        preconditionFailure("\(#function) must be overriden in child")
    }
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


open class CollectionHeaderGenerator: ViewGenerator {

    /// Nib type, which create this generator
    open var identifier: String

    public required init(identifier: String) {
        self.identifier = identifier
    }

    open func generate() -> UICollectionReusableView {
        preconditionFailure("\(#function) must be overriden in child")
    }
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

    associatedtype ViewType

    func generate() -> ViewType
}

/// Builder for concreate type of UIView
public protocol ViewBuilder {

    associatedtype ViewType: UIView

    /// Configures view.
    ///
    /// - Parameter view: UIView that should be configured.
    func build(view: ViewType)
}

/// Protocol for selectable item.
public protocol SelectableItem: class {

    /// Invokes when user taps on the item.
    var didSelectEvent: BaseEvent<Void> { get }

    /// A Boolean value that determines whether to perform a cell deselect.
    ///
    /// If the value of this property is **true** (the default), cells deselect
    /// immediately after tap. If you set it to **false**, they don't deselect.
    var isNeedDeselect: Bool { get }
}

public protocol DeletableGenerator {
    var eventDelete: BaseEmptyEvent { get }
}

public extension SelectableItem {
    var isNeedDeselect: Bool {
        return true
    }
}

public extension TableCellGenerator where Self: ViewBuilder {
    func generate(tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.identifier.nameOfClass, for: indexPath) as? Self.ViewType else {
            return UITableViewCell()
        }

        self.build(view: cell)

        return cell as? UITableViewCell ?? UITableViewCell()
    }
}

public extension CollectionCellGenerator where Self: ViewBuilder {
    func generate(collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.identifier.nameOfClass, for: indexPath) as? Self.ViewType else {
            return UICollectionViewCell()
        }

        self.build(view: cell)

        return cell as? UICollectionViewCell ?? UICollectionViewCell()
    }
}

