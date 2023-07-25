//
//  Protocols.swift
//  ReactiveDataDisplayManager
//
//  Created by Alexander Kravchenkov on 01.08.17.
//  Copyright © 2017 Alexander Kravchenkov. All rights reserved.
//

import UIKit

// sourcery: AutoMockable
open class TableHeaderGenerator: ViewGenerator, IdOwner, TableHeaderRegisterableItem, AccessibilityStrategyProvider {

    public let id: AnyHashable

    open var labelStrategy: AccessibilityStringStrategy = .ignored
    open var traitsStrategy: AccessibilityTraitsStrategy = .just(.header)

    public init() {
		self.id = UUID().uuidString
	}

	public init(uniqueId: AnyHashable) {
		self.id = uniqueId
	}

    open func generate() -> UIView {
        preconditionFailure("\(#function) must be overriden in child")
    }

    open func height(_ tableView: UITableView, forSection section: Int) -> CGFloat {
        preconditionFailure("\(#function) must be overriden in child")
    }

    /// Registeration needed only for `UITableViewHeaderFooterView` descendant classes
    open func registerHeader(in tableView: UITableView) { }

}

open class TableFooterGenerator: ViewGenerator, TableFooterRegisterableItem {

    public let id: AnyHashable

    public init() {
        self.id = UUID().uuidString
    }

    public init(uniqueId: AnyHashable) {
        self.id = uniqueId
    }

    open func generate() -> UIView {
        preconditionFailure("\(#function) must be overriden in child")
    }

    /// Registeration needed only for `UITableViewHeaderFooterView` descendant classes
    open func registerFooter(in tableView: UITableView) { }

    open func height(_ tableView: UITableView, forSection section: Int) -> CGFloat {
        preconditionFailure("\(#function) must be overriden in child")
    }
}

// sourcery: AutoMockable
/// Protocol that incapsulated type of current cell
public protocol TableCellGenerator: AnyObject, TableCellRegisterableItem {

    /// Nib type, which create this generator
    var identifier: String { get }

    /// Creates a cell.
    ///
    /// - Parameter tableView: TableView, which controlled cell grations
    /// - Return: New (may reused) cell.
    func generate(tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell

    /// Height for cell.
    ///
    /// Default implementation returns UITableView.automaticDimension
    var cellHeight: CGFloat { get }

    /// Estimated height for cell
    ///
    /// Default implementation returns nil
    var estimatedCellHeight: CGFloat? { get }

    /// Method for SPM support
    ///
    /// If you use SPM return Bundle.module
    static func bundle() -> Bundle?
}

public extension TableCellGenerator {

    static func bundle() -> Bundle? {
        return nil
    }

}

// sourcery: AutoMockable
/// Protocol that incapsulated type of Header
public protocol CollectionHeaderGenerator: AnyObject, CollectionHeaderRegisterableItem, AccessibilityStrategyProvider {

    var identifier: UICollectionReusableView.Type { get }

    func generate(collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionReusableView

    func size(_ collectionView: UICollectionView, forSection section: Int) -> CGSize

    /// Method for SPM support
    ///
    /// If you use SPM return Bundle.module
    static func bundle() -> Bundle?
}

public extension CollectionHeaderGenerator {

    static func bundle() -> Bundle? {
        return nil
    }

    var labelStrategy: AccessibilityStringStrategy { .ignored }
    var traitsStrategy: AccessibilityTraitsStrategy { .just(.header) }

}

// sourcery: AutoMockable
/// Protocol that incapsulated type of Footer
public protocol CollectionFooterGenerator: AnyObject, CollectionFooterRegisterableItem {

    var identifier: UICollectionReusableView.Type { get }

    func generate(collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionReusableView

    func size(_ collectionView: UICollectionView, forSection section: Int) -> CGSize
}

// sourcery: AutoMockable
/// Protocol that incapsulated type of current cell
public protocol CollectionCellGenerator: AnyObject, CollectionCellRegisterableItem {

    /// Nib type, which create this generator
    var identifier: String { get }

    /// Creates a cell.
    ///
    /// - Parameter tableView: TableView, which controlled cell grations
    /// - Return: New (may reused) cell.
    func generate(collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionViewCell

    /// Method for SPM support
    /// 
    /// If you use SPM return Bundle.module
    static func bundle() -> Bundle?
}

public extension CollectionCellGenerator {

    static func bundle() -> Bundle? {
        return nil
    }

}

/// Protocol that incapsulated build logics for current View
public protocol ViewGenerator: AnyObject {

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

public extension TableCellGenerator {

    var cellHeight: CGFloat {
        return UITableView.automaticDimension
    }

    var estimatedCellHeight: CGFloat? {
        return nil
    }

}

public extension TableCellGenerator where Self: ViewBuilder {

    func generate(tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.identifier, for: indexPath) as? Self.ViewType else {
            return UITableViewCell()
        }

        self.build(view: cell)

        return cell as? UITableViewCell ?? UITableViewCell()
    }

    func registerCell(in tableView: UITableView) {
        tableView.registerNib(self.identifier, bundle: Self.bundle())
    }

}

public extension CollectionCellGenerator where Self: ViewBuilder {

    func generate(collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.identifier, for: indexPath) as? Self.ViewType else {
            return UICollectionViewCell()
        }

        self.build(view: cell)

        return cell as? UICollectionViewCell ?? UICollectionViewCell()
    }

    func registerCell(in collectionView: UICollectionView) {
        collectionView.registerNib(self.identifier, bundle: Self.bundle())
    }

}

/// Protocol that incapsulated type of Header cell
public extension CollectionHeaderGenerator where Self: ViewBuilder {
    func generate(collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                           withReuseIdentifier: self.identifier.nameOfClass,
                                                                           for: indexPath) as? Self.ViewType else {
            return UICollectionReusableView()
        }

        self.build(view: header)

        return header as? UICollectionReusableView ?? UICollectionReusableView()
    }

    func registerHeader(in collectionView: UICollectionView) {
        collectionView.registerNib(self.identifier,
                                   kind: UICollectionView.elementKindSectionHeader,
                                   bundle: Self.bundle())
    }
}

/// Protocol that incapsulated type of Footer cell
public extension CollectionFooterGenerator where Self: ViewBuilder {
    func generate(collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionReusableView {
        guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter,
                                                                           withReuseIdentifier: self.identifier.nameOfClass,
                                                                           for: indexPath) as? Self.ViewType else {
            return UICollectionReusableView()
        }

        self.build(view: footer)

        return footer as? UICollectionReusableView ?? UICollectionReusableView()
    }

    func registerFooter(in collectionView: UICollectionView) {
        collectionView.registerNib(self.identifier, kind: UICollectionView.elementKindSectionFooter)
    }
}

/// Protocol that incapsulated type of current cell
public protocol StackCellGenerator: AnyObject {
    func generate(stackView: UIStackView, index: Int) -> UIView
}

public extension StackCellGenerator where Self: ViewBuilder {
    func generate(stackView: UIStackView, index: Int) -> UIView {
        let view = Self.ViewType()
        self.build(view: view)
        return view
    }
}

public typealias GravityTableCellGenerator = TableCellGenerator & GravityItem

open class GravityTableHeaderGenerator: TableHeaderGenerator, GravityItem {
    open var heaviness = 0

    open func getHeaviness() -> Int {
        preconditionFailure("\(#function) must be overriden in child")
    }
}

open class GravityTableFooterGenerator: TableFooterGenerator, GravityItem {
    open var heaviness = 0

    open func getHeaviness() -> Int {
        preconditionFailure("\(#function) must be overriden in child")
    }
}

// MARK: - Equatable

extension GravityTableHeaderGenerator: Equatable {
    public static func == (lhs: GravityTableHeaderGenerator, rhs: GravityTableHeaderGenerator) -> Bool {
        return lhs.generate() == rhs.generate() && lhs.getHeaviness() == rhs.getHeaviness()
    }
}
