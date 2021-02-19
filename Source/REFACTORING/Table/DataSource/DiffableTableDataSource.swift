//
//  DiffableTableDataSource.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 03.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import Foundation

@available(iOS 13.0, *)
public typealias DiffableSnapshot = NSDiffableDataSourceSnapshot<DiffableItem, DiffableItem>

/// All diffable cells and headers should include this item
open class DiffableItem: NSObject {

    // MARK: - Properties

    public var identifier: String

    // MARK: - Initialization

    public init(identifier: String) {
        self.identifier = identifier
    }

    // MARK: - Public Methods

    public override var hash: Int {
        var hasher = Hasher()
        hasher.combine(identifier)
        return hasher.finalize()
    }

    public override func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? DiffableItem else { return false }
        return identifier == object.identifier
    }

}

@available(iOS 13.0, *)
open class DiffableTableDataSource: UITableViewDiffableDataSource<DiffableItem, DiffableItem>, TableDataSource {

    // MARK: - Properties

    public weak var provider: TableGeneratorsProvider?
    public var prefetchPlugins = PluginCollection<BaseTablePlugin<PrefetchEvent>>()
    public var tablePlugins = PluginCollection<BaseTablePlugin<TableEvent>>()
    public var sectionTitleDisplayablePlugin: TableSectionTitleDisplayable?
    public var movablePlugin: TableMovableDataSource?
    
    // MARK: - Initialization

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
        movablePlugin?.moveRow(at: sourceIndexPath, to: destinationIndexPath, with: provider as? BaseTableManager)
    }

    open override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return movablePlugin?.canMoveRow(at: indexPath, with: provider as? BaseTableManager) ?? false
    }

}

// MARK: - UITableViewDataSourcePrefetching

@available(iOS 13.0, *)
extension DiffableTableDataSource: UITableViewDataSourcePrefetching {

    open func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        prefetchPlugins.process(event: .prefetch(indexPaths), with: provider as? DiffableTableStateManager)
    }

    open func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        prefetchPlugins.process(event: .cancelPrefetching(indexPaths), with: provider as? DiffableTableStateManager)
    }

}
