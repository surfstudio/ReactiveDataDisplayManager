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

    /// Register cell in tableView
    ///
    /// - Parameter in: TableView, in which cell will be registered
    func registerCell(in tableView: UITableView)

    /// Returns height for cell.
    ///
    /// Default implementation returns UITableView.automaticDimension
    func heightForCell() -> CGFloat
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

    /// Register cell in collectionView
    ///
    /// - Parameter in: CollectionView, in which cell will be registered
    func registerCell(in collectionView: UICollectionView)
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

public protocol DisplayableFlow: class {

    /// Invokes when cell will displaying.
    var willDisplayEvent: BaseEvent<Void> { get }

    /// Invokes when cell did end displaying.
    var didEndDisplayEvent: BaseEvent<Void> { get }

}

public protocol DeletableGenerator {
    var eventDelete: BaseEmptyEvent { get }
}

public extension SelectableItem {

    var isNeedDeselect: Bool {
        return true
    }

}

public extension TableCellGenerator {

    func heightForCell() -> CGFloat {
        return UITableView.automaticDimension
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

    func registerCell(in tableView: UITableView) {
        tableView.registerNib(self.identifier)
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

    func registerCell(in collectionView: UICollectionView) {
        collectionView.registerNib(self.identifier)
    }

}

