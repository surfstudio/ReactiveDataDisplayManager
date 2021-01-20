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
open class BaseTableDataSource<G: TableGeneratorsProvider>: NSObject, TableDataSource {

    // MARK: - Properties

    weak var stateManager: G?

    init(stateManager: G) {
        self.stateManager = stateManager
    }

    // MARK: - UITableViewDataSource

    open func numberOfSections(in tableView: UITableView) -> Int {
        return stateManager?.sections.count ?? 0
    }

    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let stateManager = stateManager else {
            return 0
        }
        if stateManager.generators.indices.contains(section) {
            return stateManager.generators[section].count
        }
        return 0
    }

    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return stateManager?.generators[indexPath.section][indexPath.row].generate(tableView: tableView, for: indexPath) ?? UITableViewCell()
    }

}
