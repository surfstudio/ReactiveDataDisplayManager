//
//  Table+RDDM.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 21.01.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

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

    // MARK: - Properties

    let view: UITableView
    let manager: T
    var delegate: BaseTableDelegate
    var dataSource: BaseTableDataSource

    var tablePlugins = TablePluginsCollection()
    var scrollPlugins = ScrollPluginsCollection()
    var prefetchPlugins = PrefetchPluginsCollection()
    var featurePlugins = [FeaturePlugin]()

    // MARK: - Initialization

    init(view: UITableView, manager: T) {
        self.view = view
        self.manager = manager
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

    /// Add feature plugin functionality based on UITableViewDelegate/UITableViewDataSource events
    public func add(featurePlugin: FeaturePlugin) -> TableBuilder<T> {
        featurePlugins.append(featurePlugin)
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
        delegate.tablePlugins = tablePlugins
        delegate.scrollPlugins = scrollPlugins
        delegate.featurePlugins = featurePlugins
        view.delegate = delegate

        dataSource.provider = manager
        dataSource.featurePlugins = featurePlugins
        dataSource.tablePlugins = tablePlugins

        view.dataSource = dataSource

        if #available(iOS 10.0, *) {
            dataSource.prefetchPlugins = prefetchPlugins
            view.prefetchDataSource = dataSource
        }

        manager.view = view
        manager.delegate = delegate
        manager.dataSource = dataSource
        return manager
    }

}
