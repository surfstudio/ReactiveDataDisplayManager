//
//  BaseTableAdapter.swift
//  ReactiveDataDisplayManager
//
//  Created by Aleksandr Smirnov on 02.11.2020.
//  Copyright © 2020 Александр Кравченков. All rights reserved.
//

import Foundation

///Base implementation of table adapter. Acts as composer for StateManager, Delegate and DataSource, proxies all operations with generators.
open class BaseTableAdapter: AbstractAdapter {

    // MARK: - Typealiases

    public typealias CollectionType = UITableView
    public typealias CollectionStateManagerType = BaseTableStateManager
    public typealias CollectionDelegateType = BaseTableDelegate
    public typealias CollectionDataSourceType = BaseTableDataSource
    public typealias HeaderGeneratorType = TableHeaderGenerator

    // MARK: - Events

    /// Called if table scrolled
    public var scrollEvent = BaseEvent<UITableView>()
    public var scrollViewWillEndDraggingEvent: BaseEvent<CGPoint> = BaseEvent<CGPoint>()
    public var cellChangedPosition = BaseEvent<(oldIndexPath: IndexPath, newIndexPath: IndexPath)>()

    /// Celled when cells displaying
    public var willDisplayCellEvent = BaseEvent<(TableCellGenerator, IndexPath)>()
    public var didEndDisplayCellEvent = BaseEvent<(TableCellGenerator, IndexPath)>()

    // MARK: - Private(set) Properties

    private(set) var tableView: UITableView
    private(set) var stateManager: BaseTableStateManager

    // MARK: - Private Properties

    private var delegate: UITableViewDelegate?
    private var dataSource: UITableViewDataSource?

    // MARK: - Initialization

    public required init(collection: UITableView,
                         stateManager: BaseTableStateManager = BaseTableStateManager(),
                         delegate: BaseTableDelegate = BaseTableDelegate(),
                         dataSource: BaseTableDataSource = BaseTableDataSource()) {
        self.tableView = collection

        self.stateManager = stateManager
        self.stateManager.adapter = self

        self.tableView.delegate = delegate
        delegate.adapter = self
        self.delegate = delegate

        self.tableView.dataSource = dataSource
        dataSource.adapter = self
        self.dataSource = dataSource
    }

    // MARK: - Public methods

    open func addSection(header generator: TableHeaderGenerator, cells: [TableCellGenerator]) {
        self.stateManager.addSection(header: generator, cells: cells)
    }

    open func addSectionHeaderGenerator(_ generator: TableHeaderGenerator) {
        self.stateManager.addSectionHeaderGenerator(generator)
    }

    open func insert(headGenerator: TableHeaderGenerator, after: TableHeaderGenerator) {
        self.stateManager.insert(headGenerator: headGenerator, after: after)
    }

    open func insert(headGenerator: TableHeaderGenerator, before: TableHeaderGenerator) {
        self.stateManager.insert(headGenerator: headGenerator, before: before)
    }

    open func addCellGenerator(_ generator: TableCellGenerator) {
        self.stateManager.addCellGenerator(generator)
    }

    open func addCellGenerators(_ generators: [TableCellGenerator]) {
        self.stateManager.addCellGenerators(generators)
    }

    open func addCellGenerator(_ generator: TableCellGenerator, after: TableCellGenerator) {
        self.stateManager.addCellGenerators([generator], after: after)
    }

    open func addCellGenerators(_ generators: [TableCellGenerator], after: TableCellGenerator) {
        self.stateManager.addCellGenerators(generators, after: after)
    }

    open func update(generators: [TableCellGenerator]) {
        self.stateManager.update(generators: generators)
    }

    open func clearCellGenerators() {
        self.stateManager.clearCellGenerators()
    }

    open func clearHeaderGenerators() {
        self.stateManager.clearHeaderGenerators()
    }

    open func forceRefill() {
        self.stateManager.forceRefill()
    }

    open func forceRefill(completion: @escaping (() -> Void)) {
        self.stateManager.forceRefill(completion: completion)
    }

    open func reloadSection(by sectionHeaderGenerator: TableHeaderGenerator, with animation: UITableView.RowAnimation = .none) {
        self.stateManager.reloadSection(by: sectionHeaderGenerator, with: animation)
    }

    open func addCellGenerators(_ generators: [TableCellGenerator], toHeader header: TableHeaderGenerator) {
        self.stateManager.addCellGenerators(generators, toHeader: header)
    }

    open func removeAllGenerators(from header: TableHeaderGenerator) {
        self.stateManager.removeAllGenerators(from: header)
    }

    open func addCellGenerator(_ generator: TableCellGenerator, toHeader header: TableHeaderGenerator) {
        self.stateManager.addCellGenerators([generator], toHeader: header)
    }

    open func remove(_ generator: TableCellGenerator,
                     with animation: UITableView.RowAnimation = .automatic,
                     needScrollAt scrollPosition: UITableView.ScrollPosition? = nil,
                     needRemoveEmptySection: Bool = false) {
        self.stateManager.remove(generator, with: animation, needScrollAt: scrollPosition, needRemoveEmptySection: needRemoveEmptySection)
    }

    open func insert(headGenerator: TableHeaderGenerator,
                     by index: Int,
                     generators: [TableCellGenerator],
                     with animation: UITableView.RowAnimation = .automatic) {
        self.stateManager.insert(headGenerator: headGenerator, by: index, generators: generators, with: animation)
    }

    open func insertSection(before header: TableHeaderGenerator,
                            new sectionHeader: TableHeaderGenerator,
                            generators: [TableCellGenerator],
                            with animation: UITableView.RowAnimation = .automatic) {
        self.stateManager.insertSection(before: header, new: sectionHeader, generators: generators, with: animation)
    }

    open func insertSection(after header: TableHeaderGenerator,
                            new sectionHeader: TableHeaderGenerator,
                            generators: [TableCellGenerator],
                            with animation: UITableView.RowAnimation = .automatic) {
        self.stateManager.insertSection(after: header, new: sectionHeader, generators: generators, with: animation)
    }

    open func insert(after generator: TableCellGenerator,
                     new newGenerators: [TableCellGenerator],
                     with animation: UITableView.RowAnimation = .automatic) {
        self.stateManager.insert(after: generator, new: newGenerators, with: animation)
    }

    open func insert(before generator: TableCellGenerator,
                     new newGenerators: [TableCellGenerator],
                     with animation: UITableView.RowAnimation = .automatic) {
        self.stateManager.insert(before: generator, new: newGenerators, with: animation)
    }

    open func insert(after generator: TableCellGenerator,
                     new newGenerator: TableCellGenerator,
                     with animation: UITableView.RowAnimation = .automatic) {
        self.stateManager.insert(after: generator, new: newGenerator, with: animation)
    }

    open func insert(before generator: TableCellGenerator,
                     new newGenerator: TableCellGenerator,
                     with animation: UITableView.RowAnimation = .automatic) {
        self.stateManager.insert(before: generator, new: newGenerator, with: animation)
    }

    open func insert(to header: TableHeaderGenerator,
                     new generator: TableCellGenerator,
                     with animation: UITableView.RowAnimation = .automatic) {
        self.stateManager.insert(to: header, new: generator, with: animation)
    }

    open func insertAtBeginning(to header: TableHeaderGenerator,
                                new generators: [TableCellGenerator],
                                with animation: UITableView.RowAnimation = .automatic) {
        self.stateManager.insertAtBeginning(to: header, new: generators, with: animation)
    }

    open func insertAtEnd(to header: TableHeaderGenerator,
                          new generators: [TableCellGenerator],
                          with animation: UITableView.RowAnimation = .automatic) {
        self.stateManager.insertAtEnd(to: header, new: generators, with: animation)
    }

    open func replace(oldGenerator: TableCellGenerator,
                      on newGenerator: TableCellGenerator,
                      removeAnimation: UITableView.RowAnimation = .automatic,
                      insertAnimation: UITableView.RowAnimation = .automatic) {
        self.stateManager.replace(oldGenerator: oldGenerator, on: newGenerator, removeAnimation: removeAnimation, insertAnimation: insertAnimation)
    }

    open func swap(generator firstGenerator: TableCellGenerator, with secondGenerator: TableCellGenerator) {
        self.stateManager.swap(generator: firstGenerator, with: secondGenerator)
    }

}
