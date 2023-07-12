//
//  BaseTableDataSource.swift
//  ReactiveDataDisplayManager
//
//  Created by Aleksandr Smirnov on 02.11.2020.
//  Copyright © 2020 Александр Кравченков. All rights reserved.
//

import UIKit
import Foundation

/// Base implementation for `UITableViewDataSource` protocol.
open class BaseTableDataSource: NSObject, TableDataSource {

    // MARK: - Typealias

    typealias TableAnimator = Animator<BaseTableManager.CollectionType>

    // MARK: - Properties

    public weak var provider: TableGeneratorsProvider?

    public var modifier: Modifier<UITableView, UITableView.RowAnimation>?

    public var prefetchPlugins = PluginCollection<BaseTablePlugin<PrefetchEvent>>()
    public var tablePlugins = PluginCollection<BaseTablePlugin<TableEvent>>()
    public var sectionTitleDisplayablePlugin: TableSectionTitleDisplayable?
    public var movablePlugin: MovablePluginDataSource<TableGeneratorsProvider>?

    // MARK: - Private Properties

    private var animator: TableAnimator?

}

// MARK: - TableBuilderConfigurable

extension BaseTableDataSource {

    public func configure<T>(with builder: TableBuilder<T>) where T: BaseTableManager {

        modifier = TableCommonModifier(view: builder.view, animator: builder.animator)

        animator = builder.animator
        movablePlugin = builder.movablePlugin?.dataSource
        sectionTitleDisplayablePlugin = builder.sectionTitleDisplayablePlugin
        tablePlugins = builder.tablePlugins

        if #available(iOS 10.0, tvOS 10.0, *) {
            prefetchPlugins = builder.prefetchPlugins
        }

        provider = builder.manager

        prefetchPlugins.setup(with: builder.manager)
        tablePlugins.setup(with: builder.manager)
    }
}

// MARK: - UITableViewDataSource

extension BaseTableDataSource {

    open func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitleDisplayablePlugin?.numberOfSections(with: provider) ?? provider?.sections.count ?? 0
    }

    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let provider = provider, provider.generators.indices.contains(section) else {
            return 0
        }
        return provider.generators[section].count
    }

    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let provider = provider else {
            return UITableViewCell()
        }
        let cell = provider
            .generators[indexPath.section][indexPath.row]
            .generate(tableView: tableView, for: indexPath)

        configureExpandableItem(for: cell, tableView: tableView)
        return cell
    }

    open func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        movablePlugin?.moveRow(at: sourceIndexPath, to: destinationIndexPath, with: provider, and: tableView, animator: animator)
        tablePlugins.process(event: .move(from: sourceIndexPath, to: destinationIndexPath), with: provider as? BaseTableManager)
    }

    open func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return movablePlugin?.canMoveRow(at: indexPath, with: provider) ?? false
    }

    open func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionTitleDisplayablePlugin?.sectionIndexTitles(with: provider)
    }

    open func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return sectionTitleDisplayablePlugin?.sectionForSectionIndexTitle(title, at: index, with: provider) ?? -1
    }

}

// MARK: - UITableViewDataSourcePrefetching

extension BaseTableDataSource {

    open func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        prefetchPlugins.process(event: .prefetch(indexPaths), with: provider as? BaseTableManager)
    }

    open func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        prefetchPlugins.process(event: .cancelPrefetching(indexPaths), with: provider as? BaseTableManager)
    }

}

// MARK: - ExpandableItem

private extension BaseTableDataSource {

    func configureExpandableItem(for cell: UITableViewCell, tableView: UITableView) {
        guard let expandable = cell as? ExpandableItem else {
            return
        }
        expandable.onHeightChanged.addListner(with: "rddm.expandable-on-dequeue") { [weak self, weak expandable, weak tableView] _ in
            guard let tableView = tableView,
                  let animated = expandable?.animatedExpandable else {
                return
            }
            self?.animator?.perform(in: tableView,
                                    animated: animated,
                                    operation: nil)
        }
    }

}
