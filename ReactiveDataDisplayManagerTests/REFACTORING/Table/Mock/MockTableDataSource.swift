//
//  MockTableDataSource.swift
//  ReactiveDataDisplayManagerTests
//
//  Created by Anton Eysner on 08.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//
import UIKit

@testable import ReactiveDataDisplayManager

final class MockTableDataSource: NSObject, TableDataSource {

    weak var provider: TableGeneratorsProvider?
    var modifier: Modifier<UITableView, UITableView.RowAnimation>?
    var prefetchPlugins = PluginCollection<BaseTablePlugin<PrefetchEvent>>()
    var tablePlugins = PluginCollection<BaseTablePlugin<TableEvent>>()
    var sectionTitleDisplayablePlugin: TableSectionTitleDisplayable?
    var movablePlugin: MovablePluginDataSource<TableGeneratorsProvider>?

    func numberOfSections(in tableView: UITableView) -> Int {
        return provider?.sections.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard
            let provider = provider,
            provider.generators.indices.contains(section)
        else {
            return 0
        }
        return provider.generators[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {}

    func configure<T>(with builder: TableBuilder<T>) where T : BaseTableManager {}

}
