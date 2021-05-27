//
//  CollectionBuilder.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 15.03.2021.
//

import UIKit

extension UICollectionView: DataDisplayCompatible {}

public extension DataDisplayWrapper where Base: UICollectionView {

    /// Builder of `BaseCollectionManager`
    var baseBuilder: CollectionBuilder<BaseCollectionManager> {
        CollectionBuilder(view: base, manager: BaseCollectionManager())

public class CollectionBuilder<T: BaseCollectionManager> {

    // MARK: - Aliases

    typealias CollectionPluginsCollection = PluginCollection<BaseCollectionPlugin<CollectionEvent>>
    typealias ScrollPluginsCollection = PluginCollection<BaseCollectionPlugin<ScrollEvent>>
    typealias PrefetchPluginsCollection = PluginCollection<BaseCollectionPlugin<PrefetchEvent>>

    public typealias CollectionAnimator = Animator<BaseCollectionManager.CollectionType>

    // MARK: - Properties

    let view: UICollectionView
    let manager: T
    var delegate: CollectionDelegate
    var dataSource: CollectionDataSource
    var animator: CollectionAnimator

    var collectionPlugins = CollectionPluginsCollection()
    var scrollPlugins = ScrollPluginsCollection()
    var prefetchPlugins = PrefetchPluginsCollection()
    var itemTitleDisplayablePlugin: CollectionItemTitleDisplayable?

    // MARK: - Initialization

    init(view: UICollectionView, manager: T) {
        self.view = view
        self.manager = manager
        self.manager.view = view

        delegate = BaseCollectionDelegate()
        dataSource = BaseCollectionDataSource()
        animator = CollectionBatchUpdatesAnimator()
    }

    // MARK: - Public Methods

    /// Change delegate
    public func set(delegate: CollectionDelegate) -> CollectionBuilder<T> {
        self.delegate = delegate
        return self
    }

    /// Change dataSource
    public func set(dataSource: (BaseCollectionManager) -> CollectionDataSource) -> CollectionBuilder<T> {
        self.dataSource = dataSource(manager)
    }

    /// Change animator
    public func set(animator: CollectionAnimator) -> CollectionBuilder<T> {
        self.animator = animator
        return self
    }

    /// Add feature plugin functionality based on UICollectionViewDelegate/UICollectionViewDataSource events
    public func add(featurePlugin: CollectionFeaturePlugin) -> CollectionBuilder<T> {
        guard let plugin = featurePlugin as? CollectionItemTitleDisplayable else { return self }
        itemTitleDisplayablePlugin = plugin
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
        manager.view = view

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
