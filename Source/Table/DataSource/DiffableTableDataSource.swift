//
//  DiffableTableDataSource.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 03.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

@available(iOS 13.0, tvOS 13.0, *)
public typealias DiffableSnapshot = NSDiffableDataSourceSnapshot<DiffableItem, DiffableItem>

/// DataSource based on `UITableViewDiffableDataSource` with automatic cells managing
///
/// - Warning: Required to conform all generators to `DiffableItemSource`
@available(iOS 13.0, tvOS 13.0, *)
open class DiffableTableDataSource: UITableViewDiffableDataSource<DiffableItem, DiffableItem>, TableDataSource {

    // MARK: - Properties

    public weak var provider: TableGeneratorsProvider? {
        didSet {
            let manager = provider as? BaseTableManager
            prefetchPlugins.setup(with: manager)
            tablePlugins.setup(with: manager)
        }
    }

    public var modifier: Modifier<UITableView, UITableView.RowAnimation>?

    public var prefetchPlugins = PluginCollection<BaseTablePlugin<PrefetchEvent>>()
    public var tablePlugins = PluginCollection<BaseTablePlugin<TableEvent>>()
    public var sectionTitleDisplayablePlugin: TableSectionTitleDisplayable?
    public var movablePlugin: MovablePluginDataSource<TableGeneratorsProvider>?

    // MARK: - Initialization

    /// - parameter provider: provider of `UITableView` and `UITableViewCells`
    public init(provider: BaseTableManager) {

        super.init(tableView: provider.view) { (table, indexPath, item) -> UITableViewCell? in
            return provider
                .generators[indexPath.section][indexPath.row]
                .generate(tableView: table, for: indexPath)
        }

        self.provider = provider
    }

    // MARK: - UITableViewDiffableDataSource

    open override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        tablePlugins.process(event: .move(from: sourceIndexPath, to: destinationIndexPath), with: provider as? BaseTableManager)
        movablePlugin?.moveRow(at: sourceIndexPath, to: destinationIndexPath, with: provider, and: tableView, animator: nil)
    }

    open override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return movablePlugin?.canMoveRow(at: indexPath, with: provider) ?? false
    }

    open override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }

}

// MARK: - TableBuilderConfigurable

@available(iOS 13.0, tvOS 13.0, *)
extension DiffableTableDataSource {

    public func configure<T>(with builder: TableBuilder<T>) where T: BaseTableManager {

        modifier = TableDiffableModifier(view: builder.view, provider: builder.manager, dataSource: self)

        movablePlugin = builder.movablePlugin?.dataSource
        sectionTitleDisplayablePlugin = builder.sectionTitleDisplayablePlugin
        tablePlugins = builder.tablePlugins
        prefetchPlugins = builder.prefetchPlugins

        provider = builder.manager

        prefetchPlugins.setup(with: builder.manager)
        tablePlugins.setup(with: builder.manager)
    }

}

// MARK: - UITableViewDataSourcePrefetching

@available(iOS 13.0, tvOS 13.0, *)
extension DiffableTableDataSource {

    open func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        prefetchPlugins.process(event: .prefetch(indexPaths), with: provider as? BaseTableManager)
    }

    open func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        prefetchPlugins.process(event: .cancelPrefetching(indexPaths), with: provider as? BaseTableManager)
    }

}
