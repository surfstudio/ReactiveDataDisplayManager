//
//  CollectionBuilder.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 15.03.2021.
//

import UIKit

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

    var emptyAnimatorDebounceTime: DispatchTimeInterval = .milliseconds(150)

    var collectionPlugins = CollectionPluginsCollection()
    var scrollPlugins = ScrollPluginsCollection()
    var prefetchPlugins = PrefetchPluginsCollection()
    var itemTitleDisplayablePlugin: CollectionItemTitleDisplayable?
    var swipeActionsPlugin: CollectionFeaturePlugin?
    var movablePlugin: CollectionMovableItemPlugin?
    #if os(tvOS)
    var focusablePlugin: CollectionFocusablePlugin?
    #endif

    #if os(iOS)
    @available(iOS 11.0, *)
    var dragAndDroppablePlugin: CollectionDragAndDroppablePlugin? {
        set { _dragAndDroppablePlugin = newValue }
        get { _dragAndDroppablePlugin as? CollectionDragAndDroppablePlugin }
    }
    #endif

    // MARK: - Private Properties

    private var _dragAndDroppablePlugin: CollectionFeaturePlugin?

    // MARK: - Initialization

    public init(view: UICollectionView, manager: T) {
        self.view = view
        self.manager = manager
        self.manager.view = view

        delegate = BaseCollectionDelegate()
        dataSource = BaseCollectionDataSource()
        animator = CollectionBatchUpdatesAnimator()
    }

    // MARK: - Public Methods

    /// `emptyAnimatorDebounceTime` which used in `QueuedAnimator`  to improve performance of empty animation processing.
    /// - Default value is equal to 150 milliseconds.
    public func set(emptyAnimatorDebounceTime: DispatchTimeInterval) -> CollectionBuilder<T> {
        self.emptyAnimatorDebounceTime = emptyAnimatorDebounceTime
        return self
    }

    /// Change delegate
    public func set(delegate: CollectionDelegate) -> CollectionBuilder<T> {
        self.delegate = delegate
        return self
    }

    /// Change dataSource
    public func set(dataSource: (BaseCollectionManager) -> CollectionDataSource) -> CollectionBuilder<T> {
        self.dataSource = dataSource(manager)
        return self
    }

    /// Change animator
    public func set(animator: CollectionAnimator) -> CollectionBuilder<T> {
        self.animator = animator
        return self
    }

    /// Add feature plugin functionality based on UICollectionViewDelegate/UICollectionViewDataSource events
    public func add(featurePlugin: CollectionFeaturePlugin) -> CollectionBuilder<T> {
        #if os(iOS)
        let needTrySetPlugin = [
            !trySetSwipeActions(plugin: featurePlugin),
            !trySetDragAndDroppable(plugin: featurePlugin)
        ].allSatisfy { $0 }

        guard needTrySetPlugin else { return self }
        #endif

        switch featurePlugin {
        case let plugin as CollectionMovableItemPlugin:
            movablePlugin == nil ? movablePlugin = plugin : printDebugMessage(plugin)
        case let plugin as CollectionItemTitleDisplayable:
            itemTitleDisplayablePlugin == nil ? itemTitleDisplayablePlugin = plugin : printDebugMessage(plugin)
        #if os(tvOS)
        case let plugin as CollectionFocusablePlugin:
            focusablePlugin == nil ? focusablePlugin = plugin : printDebugMessage(plugin)
        #endif
        default:
            break
        }

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
    @available(iOS 10.0, tvOS 10.0, *)
    public func add(plugin: BaseCollectionPlugin<PrefetchEvent>) -> CollectionBuilder<T> {
        prefetchPlugins.add(plugin)
        return self
    }

    /// Build delegate, dataSource, view and data display manager together and returns DataDisplayManager
    public func build() -> T {
        manager.view = view

        animator = QueuedAnimator(baseAnimator: CollectionSafeAnimator(baseAnimator: animator,
                                                                       generatorsProvider: manager),
                                  debounceTime: emptyAnimatorDebounceTime)

        delegate.configure(with: self)
        view.delegate = delegate

        #if os(iOS)
        if #available(iOS 11.0, *) {
            view.dragDelegate = delegate as? CollectionDragAndDropDelegate
            view.dropDelegate = delegate as? CollectionDragAndDropDelegate
        }
        #endif

        dataSource.configure(with: self)
        view.dataSource = dataSource

        if #available(iOS 10.0, tvOS 10.0, *) {
            view.prefetchDataSource = dataSource
        }

        manager.delegate = delegate
        manager.dataSource = dataSource
        return manager
    }

}

// MARK: - Private Methods

private extension CollectionBuilder {
    #if os(iOS)
    func trySetSwipeActions(plugin: CollectionFeaturePlugin) -> Bool {
        guard #available(iOS 14.0, *),
              let plugin = plugin as? CollectionSwipeActionsConfigurable
        else { return false }

        plugin.manager = manager
        swipeActionsPlugin = plugin
        return true
    }

    func trySetDragAndDroppable(plugin: CollectionFeaturePlugin) -> Bool {
        guard #available(iOS 11.0, *),
              let plugin = plugin as? CollectionDragAndDroppablePlugin
        else { return false }

        dragAndDroppablePlugin = plugin
        return true
    }
    #endif

    func printDebugMessage(_ featurePlugin: CollectionFeaturePlugin) {
        debugPrint("❗️ Plugin \(featurePlugin.pluginName) added multiple times")
    }
}
