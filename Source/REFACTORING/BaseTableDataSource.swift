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

extension BaseTableStateManager: TableGeneratorsProvider { }


// Base implementation for UITableViewDataSource protocol. Use it if NO special logic required.
open class BaseTableDataSource: NSObject, TableDataSource {

    // MARK: - Properties

    var provider: TableGeneratorsProvider

    init(provider: TableGeneratorsProvider) {
        self.provider = provider
    }

    // MARK: - UITableViewDataSource

    open func numberOfSections(in tableView: UITableView) -> Int {
        return provider.sections.count
    }

    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if provider.generators.indices.contains(section) {
            return provider.generators[section].count
        }
        return 0
    }

    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return provider
            .generators[indexPath.section][indexPath.row]
            .generate(tableView: tableView, for: indexPath)
    }

}
