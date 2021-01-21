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
    let delegate: BaseTableDelegate
    let dataSource: BaseTableDataSource
    
    init(view: UITableView, stateManager: T) {
        self.view = view
        self.stateManager = stateManager
        delegate = BaseTableDelegate(stateManager: stateManager)
        dataSource = BaseTableDataSource(provider: stateManager)
    }

    func add(plugin: PluginAction<TableEvent, BaseTableStateManager>) -> TableBuilder<T> {
        delegate.plugins.add(plugin)
        return self
    }

    func build() -> T {
        view.delegate = delegate
        view.dataSource = dataSource
        return stateManager
    }
}
