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

    var emptyAnimatorDebounceTime: DispatchTimeInterval = .milliseconds(150)

    var tablePlugins = TablePluginsCollection()
    var scrollPlugins = ScrollPluginsCollection()
    var prefetchPlugins = PrefetchPluginsCollection()
    var movablePlugin: TableMovableItemPlugin?
    var sectionTitleDisplayablePlugin: TableSectionTitleDisplayable?
    var swipeActionsPlugin: TableFeaturePlugin?
    #if os(tvOS)
    var focusablePlugin: TableFocusablePlugin?
    #endif

    #if os(iOS)
    @available(iOS 11.0, *)
    var dragAndDroppablePlugin: TableDragAndDroppablePlugin? {
        set { _dragAndDroppablePlugin = newValue }
        get { _dragAndDroppablePlugin as? TableDragAndDroppablePlugin }
    }
    #endif

    // MARK: - Private Properties

    private var _dragAndDroppablePlugin: TableFeaturePlugin?

    // MARK: - Initialization

    public init(view: UITableView, manager: T) {
        self.view = view
        self.manager = manager
        self.manager.view = view
        delegate = BaseTableDelegate()
        dataSource = BaseTableDataSource()
        animator = {
            if #available(iOS 11.0, tvOS 11.0, *) {
                return TableBatchUpdatesAnimator()
            } else {
                return TableUpdatesAnimator()
            }
        }()
    }

    // MARK: - Public Methods

    /// `emptyAnimatorDebounceTime` which used in `QueuedAnimator`  to improve performance of empty animation processing.
    /// - Default value is equal to 150 milliseconds.
    public func set(emptyAnimatorDebounceTime: DispatchTimeInterval) -> TableBuilder<T> {
        self.emptyAnimatorDebounceTime = emptyAnimatorDebounceTime
        return self
    }

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
        #if os(iOS)
        let needTrySetPlugin = [
            !trySetSwipeActions(plugin: featurePlugin),
            !trySetDragAndDroppable(plugin: featurePlugin)
        ].allSatisfy { $0 }

        guard needTrySetPlugin else { return self }
        #endif

        switch featurePlugin {
        case let plugin as TableMovableItemPlugin:
            movablePlugin == nil ? movablePlugin = plugin : printDebugMessage(plugin)
        case let plugin as TableSectionTitleDisplayable:
            sectionTitleDisplayablePlugin == nil ? sectionTitleDisplayablePlugin = plugin : printDebugMessage(plugin)
        #if os(tvOS)
        case let plugin as TableFocusablePlugin:
            focusablePlugin == nil ? focusablePlugin = plugin : printDebugMessage(plugin)
        #endif
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
    @available(iOS 10.0, tvOS 10.0, *)
    public func add(plugin: BaseTablePlugin<PrefetchEvent>) -> TableBuilder<T> {
        prefetchPlugins.add(plugin)
        return self
    }

    /// Build delegate, dataSource, view and data display manager together and returns DataDisplayManager
    public func build() -> T {
        animator = QueuedAnimator(baseAnimator: TableSafeAnimator(baseAnimator: animator,
                                                                  generatorsProvider: manager),
                                  debounceTime: emptyAnimatorDebounceTime)

        delegate.configure(with: self)
        view.delegate = delegate

        #if os(iOS)
        if #available(iOS 11.0, *) {
            view.dragDelegate = delegate as? TableDragAndDropDelegate
            view.dropDelegate = delegate as? TableDragAndDropDelegate
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

private extension TableBuilder {
    #if os(iOS)
    func trySetSwipeActions(plugin: TableFeaturePlugin) -> Bool {
        guard #available(iOS 11.0, *),
              let plugin = plugin as? TableSwipeActionsConfigurable
        else { return false }

        swipeActionsPlugin = plugin
        return true
    }

    func trySetDragAndDroppable(plugin: TableFeaturePlugin) -> Bool {
        guard #available(iOS 11.0, *),
              let plugin = plugin as? TableDragAndDroppablePlugin
        else { return false }

        dragAndDroppablePlugin = plugin
        return true
    }
    #endif

    func printDebugMessage(_ featurePlugin: TableFeaturePlugin) {
        debugPrint("❗️ Plugin \(featurePlugin.pluginName) added multiple times")
    }
}
