//
//  Collection+RDDM.swift
//  ReactiveDataDisplayManager
//
//  Created by Vadim Tikhonov on 10.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

extension UICollectionView: DataDisplayCompatible {}

public extension DataDisplayWrapper where Base: UICollectionView {

    var baseBuilder: CollectionBuilder<BaseCollectionManager> {
        CollectionBuilder(view: base, manager: BaseCollectionManager())
    }

    var flowBuilder: CollectionBuilder<BaseCollectionManager> {
        CollectionBuilder(view: base, manager: BaseCollectionManager())
            .set(delegate: FlowCollectionDelegate())
    }

}

public class CollectionBuilder<T: BaseCollectionManager> {

    // MARK: - Aliases

    typealias CollectionPluginsCollection = PluginCollection<BaseCollectionPlugin<CollectionEvent>>
    typealias ScrollPluginsCollection = PluginCollection<BaseCollectionPlugin<ScrollEvent>>
    typealias PrefetchPluginsCollection = PluginCollection<BaseCollectionPlugin<PrefetchEvent>>

    // MARK: - Properties

    let view: UICollectionView
    let manager: T
    var delegate: CollectionDelegate
    var dataSource: CollectionDataSource

    var collectionPlugins = CollectionPluginsCollection()
    var scrollPlugins = ScrollPluginsCollection()
    var prefetchPlugins = PrefetchPluginsCollection()

    // MARK: - Initialization

    init(view: UICollectionView, manager: T) {
        self.view = view
        self.manager = manager
        delegate = BaseCollectionDelegate()
        dataSource = BaseCollectionDataSource()
    }

    // MARK: - Public Methods

    /// Change delegate
    public func set(delegate: BaseCollectionDelegate) -> CollectionBuilder<T> {
        self.delegate = delegate
        return self
    }

    /// Change dataSource
    public func set(dataSource: BaseCollectionDataSource) -> CollectionBuilder<T> {
        self.dataSource = dataSource
        return self
    }

    /// Add plugin functionality based on UICollectionViewDelegate events
    public func add(plugin: BaseCollectionPlugin<CollectionEvent>) -> CollectionBuilder<T> {
        collectionPlugins.add(plugin)
        return self
    }

    /// Add plugin functionality based on UIScrollViewDelegate events
    public func add(plugin: BaseCollectionPlugin<ScrollEvent>) -> CollectionBuilder<T> {
        scrollPlugins.add(plugin)
        return self
    }

    /// Add plugin functionality based on UICollectionViewDataSourcePrefetching events
    @available(iOS 10.0, *)
    public func add(plugin: BaseCollectionPlugin<PrefetchEvent>) -> CollectionBuilder<T> {
        prefetchPlugins.add(plugin)
        return self
    }

    /// Build delegate, dataSource, view and data display manager together and returns DataDisplayManager
    public func build() -> T {
        delegate.manager = manager
        delegate.collectionPlugins = collectionPlugins
        delegate.scrollPlugins = scrollPlugins
        view.delegate = delegate

        dataSource.provider = manager
        dataSource.collectionPlugins = collectionPlugins

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
