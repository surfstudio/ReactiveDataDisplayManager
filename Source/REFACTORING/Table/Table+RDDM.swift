//
//  Table+RDDM.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 21.01.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

extension UITableView: DataDisplayCompatible {}

public extension DataDisplayWrapper where Base: UITableView {

    var baseBuilder: TableBuilder<ManualTableStateManager> {
        TableBuilder(view: base, stateManager: ManualTableStateManager())
    }

    var gravityBuilder: TableBuilder<GravityTableStateManager> {
        TableBuilder(view: base, stateManager: GravityTableStateManager())
    }

    @available(iOS 13.0, *)
    var diffableBuilder: DiffableTableBuilder<DiffableTableStateManager> {
        DiffableTableBuilder(view: base, stateManager: DiffableTableStateManager())
    }

}

@available(iOS 13.0, *)
public class DiffableTableBuilder<T: DiffableTableStateManager>: TableBuilder<T> {

    // MARK: - Initialization

    override init(view: UITableView, stateManager: T) {
        super.init(view: view, stateManager: stateManager)
        stateManager.tableView = view
        dataSource = DiffableTableDataSource(provider: stateManager)
    }

    // MARK: - Public Methods

    public func set(dataSource: DiffableTableDataSource) -> TableBuilder<T> {
        self.dataSource = dataSource
        return self
    }

}

public class TableBuilder<T: BaseTableStateManager> {

    // MARK: - Properties

    let view: UITableView
    let stateManager: T
    var delegate: BaseTableDelegate
    var dataSource: TableDataSource

    var tablePlugins = PluginCollection<TableEvent, BaseTableStateManager>()
    var scrollPlugins = PluginCollection<ScrollEvent, BaseTableStateManager>()
    var prefetchPlugins = PluginCollection<PrefetchEvent, BaseTableStateManager>()

    // MARK: - Initialization

    init(view: UITableView, stateManager: T) {
        self.view = view
        self.stateManager = stateManager
        delegate = BaseTableDelegate()
        dataSource = BaseTableDataSource()
    }

    // MARK: - Public Methods

    /// Change delegate
    public func set(delegate: BaseTableDelegate) -> TableBuilder<T> {
        self.delegate = delegate
        return self
    }

    /// Change dataSource
    public func set(dataSource: BaseTableDataSource) -> TableBuilder<T> {
        self.dataSource = dataSource
        return self
    }

    /// Add plugin functionality based on UITableViewDelegate events
    public func add(plugin: PluginAction<TableEvent, BaseTableStateManager>) -> TableBuilder<T> {
        tablePlugins.add(plugin)
        return self
    }

    /// Add plugin functionality based on UIScrollViewDelegate events
    public func add(plugin: PluginAction<ScrollEvent, BaseTableStateManager>) -> TableBuilder<T> {
        scrollPlugins.add(plugin)
        return self
    }

    /// Add plugin functionality based on UITableViewDataSourcePrefetching events
    @available(iOS 10.0, *)
    public func add(plugin: PluginAction<PrefetchEvent, BaseTableStateManager>) -> TableBuilder<T> {
        prefetchPlugins.add(plugin)
        return self
    }

    /// Build delegate, dataSource, view and data display manager together and returns DataDisplayManager
    public func build() -> T {
        delegate.stateManager = stateManager
        delegate.tablePlugins = tablePlugins
        delegate.scrollPlugins = scrollPlugins
        view.delegate = delegate

        dataSource.provider = stateManager
        dataSource.tablePlugins = tablePlugins
        view.dataSource = dataSource

        setPrefetchDataSourceIfNeeded()

        stateManager.tableView = view
        stateManager.delegate = delegate
        stateManager.dataSource = dataSource
        return stateManager
    }

}

// MARK: - Private Methods

private extension TableBuilder {

    func setPrefetchDataSourceIfNeeded() {
        if #available(iOS 10.0, *) {
            dataSource.prefetchPlugins = prefetchPlugins
            view.prefetchDataSource = dataSource
        }
    }

}
