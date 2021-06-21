//
//  TableBuilder.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 05.03.2021.
//

import UIKit

public class TableBuilder<T: BaseTableManager> {

    // MARK: - Aliases

    typealias TablePluginsCollection = PluginCollection<BaseTablePlugin<TableEvent>>
    typealias ScrollPluginsCollection = PluginCollection<BaseTablePlugin<ScrollEvent>>
    typealias PrefetchPluginsCollection = PluginCollection<BaseTablePlugin<PrefetchEvent>>

    public typealias CollectionType = BaseTableManager.CollectionType

    public typealias TableAnimator = Animator<CollectionType>

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
    var swipeActionsPlugin: TableFeaturePlugin?

    // MARK: - Initialization

    init(view: UITableView, manager: T) {
        self.view = view
        self.manager = manager
        self.manager.view = view
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
    public func set(dataSource: (BaseTableManager) -> TableDataSource) -> TableBuilder<T> {
        self.dataSource = dataSource(manager)
        return self
    }

    /// Add feature plugin functionality based on UITableViewDelegate/UITableViewDataSource events
    public func add(featurePlugin: TableFeaturePlugin) -> TableBuilder<T> {
        guard !trySetSwipeActions(plugin: featurePlugin) else {
            return self
        }

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

        delegate.configure(with: self)
        view.delegate = delegate

        dataSource.configure(with: self)
        view.dataSource = dataSource
        if #available(iOS 10.0, *) {
            view.prefetchDataSource = dataSource
        }

        manager.delegate = delegate
        manager.dataSource = dataSource
        return manager
    }

}

// MARK: - Private Methods

private extension TableBuilder {

    func trySetSwipeActions(plugin: TableFeaturePlugin) -> Bool {
        guard #available(iOS 11.0, *),
              let plugin = plugin as? TableSwipeActionsConfigurable
        else { return false }

        swipeActionsPlugin = plugin
        return true
    }

}
