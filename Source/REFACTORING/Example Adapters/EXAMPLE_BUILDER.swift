//
//  EXAMPLE_BUILDER.swift
//  ReactiveDataDisplayManager
//
//  Created by Александр Кравченков on 26.11.2020.
//  Copyright © 2020 Александр Кравченков. All rights reserved.
//

import Foundation

//func buildCommon(cl: UITableView) -> BaseTableAdapter {
//    let stateManager = BaseTableStateManager()
//    return BaseTableAdapter(collection: cl,
//                            stateManager: stateManager,
//                            delegate: BaseTableDelegate(stateManager: stateManager),
//                            dataSource: BaseTableDataSource(stateManager: stateManager))
//}


//func build(cl: UITableView) -> BaseTableAdapter<BaseTableStateManager> {
//
//    let stateManager = BaseTableStateManager()
//    let delegate = BaseTableDelegate(stateManager: stateManager)
//    delegate.plugins.add(TableSelectablePlugin())
//    delegate.plugins.add(TableFoldablePlugin())
//    delegate.plugins.add(TableDisplayablePlugin())
//    delegate.plugins.add(TableLastCellIsVisiblePlugin(action: {
//        print("LastCellIsVisible")
//    }))
//    let dataSource = BaseTableDataSource(provider: stateManager)
//
//    return BaseTableAdapter(collection: cl, stateManager: stateManager, delegate: delegate, dataSource: dataSource)
//}

//func buildBaseGravity(cl: UITableView) -> BaseTableAdapter<BaseTableStateManager> {
//    let stateManager = GravityTableStateManager()
//    let delegate = BaseTableDelegate(stateManager: stateManager)
//    delegate.plugins.add(TableSelectablePlugin())
//    delegate.plugins.add(TableFoldablePlugin())
//    delegate.plugins.add(TableLastCellIsVisiblePlugin(action: {
//        print("LastCellIsVisible")
//    }))
//    let dataSource = BaseTableDataSource(provider: stateManager)
//
//    return BaseTableAdapter(collection: cl, stateManager: stateManager, delegate: delegate, dataSource: dataSource)
//}

func buildWithBuilder(cl: UITableView) -> BaseTableStateManager {
    cl.rddm.baseBuilder
        .add(plugin: TableSelectablePlugin())
        .add(plugin: TableFoldablePlugin())
        .add(plugin: TableDisplayablePlugin())
        .build()
}

func buildMovableWithBuilder(cl: UITableView) -> BaseTableStateManager {
    cl.rddm.baseBuilder
        .set(delegateCreation: { MovableTableDelegate(stateManager: $0) })
        .add(plugin: TableSelectablePlugin())
        .add(plugin: TableFoldablePlugin())
        .add(plugin: TableDisplayablePlugin())
        .build()
}

func buildGravityWithBuilder(cl: UITableView) -> BaseTableStateManager {
    cl.rddm.gravityBuilder
        .add(plugin: TableSelectablePlugin())
        .add(plugin: TableFoldablePlugin())
        .add(plugin: TableDisplayablePlugin())
        .build()
}
