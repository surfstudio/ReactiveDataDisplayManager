//
//  Table+RDDM.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 21.01.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

extension UITableView: DataDisplayCompatible {}

public extension DataDisplayWrapper where Base: UITableView {

    var baseBuilder: TableBuilder<BaseTableStateManager> {
        TableBuilder(view: base, stateManager: BaseTableStateManager())
    }

    var gravityBuilder: TableBuilder<GravityTableStateManager> {
        TableBuilder(view: base, stateManager: GravityTableStateManager())
    }

}

public class TableBuilder<T: BaseTableStateManager> {

    let view: UITableView
    let stateManager: T
    var delegate: BaseTableDelegate
    var dataSource: BaseTableDataSource

    var tablePlugins = PluginCollection<TableEvent, BaseTableStateManager>()
    var scrollPlugins = PluginCollection<ScrollEvent, BaseTableStateManager>()
    
    init(view: UITableView, stateManager: T) {
        self.view = view
        self.stateManager = stateManager
        delegate = BaseTableDelegate()
        dataSource = BaseTableDataSource()
    }

    /// Change delegate
    func set(delegate: BaseTableDelegate) -> TableBuilder<T> {
        self.delegate = delegate
        return self
    }

    /// Change dataSource
    func set(dataSource: BaseTableDataSource) -> TableBuilder<T> {
        self.dataSource = dataSource
        return self
    }

    /// Add plugin functionality based on UITableViewDelegate  events
    func add(plugin: PluginAction<TableEvent, BaseTableStateManager>) -> TableBuilder<T> {
        tablePlugins.add(plugin)
        return self
    }

    /// Add plugin functionality based on UIScrollViewDelegate  events
    func add(plugin: PluginAction<ScrollEvent, BaseTableStateManager>) -> TableBuilder<T> {
        scrollPlugins.add(plugin)
        return self
    }

    func build() -> T {

        delegate.stateManager = stateManager
        delegate.tablePlugins = tablePlugins
        delegate.scrollPlugins = scrollPlugins
        view.delegate = delegate

        dataSource.provider = stateManager
        view.dataSource = dataSource

        return stateManager
    }
}
