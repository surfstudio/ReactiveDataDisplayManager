//
//  Table+RDDM.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 21.01.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

extension UITableView: DataDisplayCompatible {}

public extension DataDisplayWrapper where Base: UITableView {

    var baseBuilder: TableBuilder {
        TableBuilder(view: base, stateManager: BaseTableStateManager())
    }

}

public class TableBuilder {

    let view: UITableView
    let stateManager: BaseTableStateManager
    let delegate: BaseTableDelegate
    let dataSource: BaseTableDataSource
    
    init(view: UITableView, stateManager: BaseTableStateManager) {
        self.view = view
        self.stateManager = stateManager
        delegate = BaseTableDelegate(stateManager: stateManager)
        dataSource = BaseTableDataSource(provider: stateManager)
    }

    func add(plugin: PluginAction<TableEvent, BaseTableStateManager>) -> TableBuilder {
        delegate.plugins.add(plugin)
        return self
    }

    func build() -> BaseTableStateManager {
        view.delegate = delegate
        view.dataSource = dataSource
        return stateManager
    }
}
