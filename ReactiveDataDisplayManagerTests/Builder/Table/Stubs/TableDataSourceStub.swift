//
//  TableDataSourceStub.swift
//  ReactiveDataDisplayManager
//
//  Created by porohov on 21.06.2022.
//

import UIKit

@testable import ReactiveDataDisplayManager

final class TableDataSourceStub: NSObject, TableDataSource {

    // MARK: - Testable Properties

    var builderConfigured = false
    var prefetchingItems = [IndexPath]()

    // MARK: - CollectionDataSource Properties

    var provider: TableSectionsProvider?
    var modifier: Modifier<UITableView, UITableView.RowAnimation>?
    var prefetchPlugins = PluginCollection<BaseTablePlugin<PrefetchEvent>>()
    var tablePlugins = PluginCollection<BaseTablePlugin<TableEvent>>()
    var sectionTitleDisplayablePlugin: TableSectionTitleDisplayable?
    var movablePlugin: MovablePluginDataSource<TableSectionsProvider>?

    // MARK: - CollectionDataSource Methods

    func configure<T>(with builder: TableBuilder<T>) where T: BaseTableManager {
        builderConfigured = true
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let provider = provider, provider.sections.indices.contains(section) else {
            return 0
        }
        return provider.sections[section].generators.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }

    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        prefetchingItems = indexPaths
    }

}
