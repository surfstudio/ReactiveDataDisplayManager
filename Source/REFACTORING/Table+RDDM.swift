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
    
    init(view: UITableView, stateManager: T) {
        self.view = view
        self.stateManager = stateManager
        delegate = BaseTableDelegate(stateManager: stateManager)
        dataSource = BaseTableDataSource()
    }

    /// Change delegate
    ///
    /// Warning. This call will erase all plugins
    func set(delegateCreation: (BaseTableStateManager) -> BaseTableDelegate) -> TableBuilder<T> {
        delegate = delegateCreation(stateManager)
        return self
    }

    /// Change dataSource
    func set(dataSourceCreation: (BaseTableStateManager) -> BaseTableDataSource) -> TableBuilder<T> {
        dataSource = dataSourceCreation(stateManager)
        return self
    }

    func add(plugin: PluginAction<TableEvent, BaseTableStateManager>) -> TableBuilder<T> {
        delegate.tablePlugins.add(plugin)
        return self
    }

    func add(plugin: PluginAction<ScrollEvent, BaseTableStateManager>) -> TableBuilder<T> {
        delegate.scrollPlugins.add(plugin)
        return self
    }

    func build() -> T {

        dataSource.provider = stateManager

        view.delegate = delegate
        view.dataSource = dataSource

        return stateManager
    }
}
