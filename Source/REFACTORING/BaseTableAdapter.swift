//
//  BaseTableAdapter.swift
//  ReactiveDataDisplayManager
//
//  Created by Aleksandr Smirnov on 02.11.2020.
//  Copyright © 2020 Александр Кравченков. All rights reserved.
//

import Foundation

//Base implementation of table adapter. Acts as composer for StateManager, Delegate and DataSource
open class BaseTableAdapter {

    // MARK: - Typealiases

    public typealias CollectionType = UITableView
    public typealias CellGeneratorType = TableCellGenerator
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

    init(tableView: UITableView,
         stateManager: BaseTableStateManager = BaseTableStateManager(),
         delegate: BaseTableDelegate = BaseTableDelegate(),
         dataSource: BaseTableDataSource = BaseTableDataSource()) {
        self.tableView = tableView

        self.stateManager = stateManager
        self.stateManager.adapter = self

        self.tableView.delegate = delegate
        delegate.adapter = self
        self.delegate = delegate

        self.tableView.dataSource = dataSource
        dataSource.adapter = self
        self.dataSource = dataSource
    }

}
