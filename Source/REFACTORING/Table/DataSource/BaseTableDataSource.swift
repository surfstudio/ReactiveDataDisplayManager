//
//  BaseTableDataSource.swift
//  ReactiveDataDisplayManager
//
//  Created by Aleksandr Smirnov on 02.11.2020.
//  Copyright © 2020 Александр Кравченков. All rights reserved.
//

import Foundation

protocol TableDataSource: UITableViewDataSource {}

public protocol TableGeneratorsProvider: AnyObject {
    var generators: [[TableCellGenerator]] { get set }
    var sections: [TableHeaderGenerator] { get set }
}

extension BaseTableManager: TableGeneratorsProvider { }


/// Base implementation for UITableViewDataSource protocol. Use it if NO special logic required.
open class BaseTableDataSource: NSObject {

    // MARK: - Properties

    weak var provider: TableGeneratorsProvider?

    var prefetchPlugins = PluginCollection<BaseTablePlugin<PrefetchEvent>>()
    var tablePlugins = PluginCollection<BaseTablePlugin<TableEvent>>()
    var featurePlugins = [FeaturePlugin]()

    // MARK: - Private Properties

    private var sectionTitleDisplayablePlugin: TableSectionTitleDisplayable? {
        return featurePlugins.elementOfType(TableSectionTitleDisplayable.self)
    }

    private var movablePlugin: TableMovable? {
        return featurePlugins.elementOfType(TableMovable.self)
    }

}

// MARK: - UITableViewDataSource

extension BaseTableDataSource: TableDataSource {

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
        return provider
            .generators[indexPath.section][indexPath.row]
            .generate(tableView: tableView, for: indexPath)
    }

    open func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        movablePlugin?.moveRow(at: sourceIndexPath, to: destinationIndexPath, with: provider)
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

extension BaseTableDataSource: UITableViewDataSourcePrefetching {

    open func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        prefetchPlugins.process(event: .prefetch(indexPaths), with: provider as? BaseTableManager)
    }

    open func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        prefetchPlugins.process(event: .cancelPrefetching(indexPaths), with: provider as? BaseTableManager)
    }

}
