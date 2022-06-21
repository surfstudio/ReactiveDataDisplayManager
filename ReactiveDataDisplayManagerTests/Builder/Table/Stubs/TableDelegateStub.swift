//
//  TableDelegateStub.swift
//  ReactiveDataDisplayManager
//
//  Created by porohov on 21.06.2022.
//

import UIKit

@testable import ReactiveDataDisplayManager

@available(iOS 11.0, *)
final class TableDelegateStub: NSObject, TableDelegate {

    // MARK: - Testable Properties

    var builderConfigured = false

    // MARK: - CollectionDelegate Properties

    var manager: BaseTableManager?
    var tablePlugins = PluginCollection<BaseTablePlugin<TableEvent>>()
    var scrollPlugins = PluginCollection<BaseTablePlugin<ScrollEvent>>()
    var movablePlugin: MovablePluginDelegate<TableGeneratorsProvider>?
    #if os(iOS)
    var swipeActionsPlugin: TableSwipeActionsConfigurable?
    #endif

    // MARK: - CollectionDelegate Methods

    func configure<T>(with builder: TableBuilder<T>) where T: BaseTableManager {
        builderConfigured = true
    }

}
