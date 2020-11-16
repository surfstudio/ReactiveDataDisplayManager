//
//  BaseTableDataSource.swift
//  ReactiveDataDisplayManager
//
//  Created by Aleksandr Smirnov on 02.11.2020.
//  Copyright © 2020 Александр Кравченков. All rights reserved.
//

import Foundation

// Base implementation for UITableViewDataSource protocol. Use it if NO special logic required.
open class BaseTableDataSource: NSObject, UITableViewDataSource {

    // MARK: - Properties

    weak var adapter: BaseTableAdapter?

    // MARK: - UITableViewDataSource

    open func numberOfSections(in tableView: UITableView) -> Int {
        return adapter?.stateManager.sections.count ?? 0
    }

    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let adapter = adapter else {
            return 0
        }
        if adapter.stateManager.generators.indices.contains(section) {
            return adapter.stateManager.generators[section].count
        }
        return 0
    }

    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return adapter?.stateManager.generators[indexPath.section][indexPath.row].generate(tableView: tableView, for: indexPath) ?? UITableViewCell()
    }

}
