//
//  Table+RDDM.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 21.01.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

extension UITableView: DataDisplayCompatible {}

public extension DataDisplayWrapper where Base: UITableView {

    var baseBuilder: TableBuilder<BaseTableManager> {
        TableBuilder(view: base, manager: BaseTableManager())
    }

    var manualBuilder: TableBuilder<ManualTableManager> {
        TableBuilder(view: base, manager: ManualTableManager())
    }

    var gravityBuilder: TableBuilder<GravityTableManager> {
        TableBuilder(view: base, manager: GravityTableManager())
    }

}

public class TableBuilder<T: BaseTableManager> {

    // MARK: - Aliases

    typealias TablePluginsCollection = PluginCollection<BaseTablePlugin<TableEvent>>
    typealias ScrollPluginsCollection = PluginCollection<BaseTablePlugin<ScrollEvent>>
    typealias PrefetchPluginsCollection = PluginCollection<BaseTablePlugin<PrefetchEvent>>

    public typealias TableAnimator = Animator<BaseTableManager.CollectionType>

    // MARK: - Properties

    let view: UITableView
    let manager: T
    var delegate: TableDelegate
    var dataSource: TableDataSource
    var animator: TableAnimator

    var tablePlugins = TablePluginsCollection()
    var scrollPlugins = ScrollPluginsCollection()
    var prefetchPlugins = PrefetchPluginsCollection()
    var movablePlugin: TableMovable?
    var sectionTitleDisplayablePlugin: TableSectionTitleDisplayable?
    var swipeActionsPlugin: FeaturePlugin?

    // MARK: - Initialization

    init(view: UITableView, manager: T) {
        self.view = view
        self.manager = manager
        delegate = BaseTableDelegate()
        dataSource = BaseTableDataSource()
        animator = {
            if #available(iOS 11, *) {
                return TableBatchUpdatesAnimator()
            } else {
                return TableUpdatesAnimator()
            }
        }()
    }

    // MARK: - Public Methods

    /// Change delegate
    public func set(delegate: TableDelegate) -> TableBuilder<T> {
        self.delegate = delegate
        return self
    }

    /// Change dataSource
    public func set(dataSource: TableDataSource) -> TableBuilder<T> {
        self.dataSource = dataSource
        return self
    }

    /// Change animator
    public func set(animator: TableAnimator) -> TableBuilder<T> {
        self.animator = animator
        return self
    }

    /// Add feature plugin functionality based on UITableViewDelegate/UITableViewDataSource events
    public func add(featurePlugin: FeaturePlugin) -> TableBuilder<T> {
        checkSwipeActionsPlugin(with: featurePlugin)

        switch featurePlugin {
        case let plugin as TableMovable:
            movablePlugin = plugin
        case let plugin as TableSectionTitleDisplayable:
            sectionTitleDisplayablePlugin = plugin
        default:
            break
        }
        return self
    }

    /// Change animator
    public func set(animator: TableAnimator) -> TableBuilder<T> {
        self.animator = animator
        return self
    }

    /// Add plugin functionality based on UITableViewDelegate/UITableViewDataSource events
    public func add(plugin: BaseTablePlugin<TableEvent>) -> TableBuilder<T> {
        tablePlugins.add(plugin)
        return self
    }

    /// Add plugin functionality based on UIScrollViewDelegate events
    public func add(plugin: BaseTablePlugin<ScrollEvent>) -> TableBuilder<T> {
        scrollPlugins.add(plugin)
        return self
    }

    /// Add plugin functionality based on UITableViewDataSourcePrefetching events
    @available(iOS 10.0, *)
    public func add(plugin: BaseTablePlugin<PrefetchEvent>) -> TableBuilder<T> {
        prefetchPlugins.add(plugin)
        return self
    }

    /// Build delegate, dataSource, view and data display manager together and returns DataDisplayManager
    public func build() -> T {
        delegate.manager = manager

        setSwipeActionsPluginIfNeeded()
        delegate.tablePlugins = tablePlugins
        delegate.scrollPlugins = scrollPlugins
        delegate.movablePlugin = movablePlugin

        view.delegate = delegate

        dataSource.provider = manager
        dataSource.movablePlugin = movablePlugin
        dataSource.sectionTitleDisplayablePlugin = sectionTitleDisplayablePlugin
        dataSource.tablePlugins = tablePlugins

        view.dataSource = dataSource

        setPrefetchDataSourceIfNeeded()

        manager.view = view
        manager.animator = animator
        manager.delegate = delegate
        manager.dataSource = dataSource
        return manager
    }

}

// MARK: - Private Methods

private extension TableBuilder {

    func checkSwipeActionsPlugin(with plugin: FeaturePlugin) {
        guard #available(iOS 11.0, *),
              let plugin = plugin as? TableSwipeActionsConfigurable
        else { return }

        swipeActionsPlugin = plugin
    }

    func setSwipeActionsPluginIfNeeded() {
        guard #available(iOS 11.0, *),
              let plugin = swipeActionsPlugin as? TableSwipeActionsConfigurable
        else { return }

        delegate.swipeActionsPlugin = plugin
    }

    func setPrefetchDataSourceIfNeeded() {
        if #available(iOS 10.0, *) {
            dataSource.prefetchPlugins = prefetchPlugins
            view.prefetchDataSource = dataSource
        }
    }

}
