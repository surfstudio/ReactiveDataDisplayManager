//
//  Collection+RDDM.swift
//  ReactiveDataDisplayManager
//
//  Created by Vadim Tikhonov on 10.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

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
    var dragAndDroppablePlugin: FeaturePlugin?
    var swipeablePlugin: CollectionSwipeActionsConfigurable?

    // MARK: - Initialization

    init(view: UICollectionView, manager: T) {
        self.view = view
        self.manager = manager
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
    public func set(dataSource: CollectionDataSource) -> CollectionBuilder<T> {
        self.dataSource = dataSource
        return self
    }

    /// Change animator
    public func set(animator: CollectionAnimator) -> CollectionBuilder<T> {
        self.animator = animator
        return self
    }

    /// Add feature plugin functionality based on UICollectionViewDelegate/UICollectionViewDataSource events
    public func add(featurePlugin: FeaturePlugin) -> CollectionBuilder<T> {
        checkDragAndDroppablePlugin(with: featurePlugin)
        checkSwipeablePlugin(with: featurePlugin)

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
        swipeablePlugin?.manager = manager

        delegate.manager = manager
        delegate.collectionPlugins = collectionPlugins
        delegate.scrollPlugins = scrollPlugins
        setDragAndDroppablePluginIfNeeded()

        view.delegate = delegate

        dataSource.provider = manager
        dataSource.collectionPlugins = collectionPlugins
        dataSource.itemTitleDisplayablePlugin = itemTitleDisplayablePlugin
        setPrefetchDataSourceIfNeeded()

        view.dataSource = dataSource

        if #available(iOS 10.0, *) {
            dataSource.prefetchPlugins = prefetchPlugins
            view.prefetchDataSource = dataSource
        }

        manager.view = view
        manager.delegate = delegate
        manager.dataSource = dataSource
        manager.animator = animator
        return manager
    }

}

private extension CollectionBuilder {

    func checkDragAndDroppablePlugin(with plugin: FeaturePlugin) {
        guard #available(iOS 11.0, *),
              let plugin = plugin as? CollectionDragAndDroppable
        else { return }

        dragAndDroppablePlugin = plugin
    }

    func setDragAndDroppablePluginIfNeeded() {
        guard #available(iOS 11.0, *),
              let plugin = dragAndDroppablePlugin as? CollectionDragAndDroppable
        else { return }

        delegate.dragAndDroppablePlugin = plugin
        view.dragDelegate = delegate
        view.dropDelegate = delegate
    }

    func checkSwipeablePlugin(with plugin: FeaturePlugin) {
        guard #available(iOS 14.0, *),
              let plugin = plugin as? CollectionSwipeActionsConfigurable
        else { return }

        swipeablePlugin = plugin
    }

    func setPrefetchDataSourceIfNeeded() {
        if #available(iOS 10.0, *) {
            dataSource.prefetchPlugins = prefetchPlugins
            view.prefetchDataSource = dataSource
        }
    }

}
