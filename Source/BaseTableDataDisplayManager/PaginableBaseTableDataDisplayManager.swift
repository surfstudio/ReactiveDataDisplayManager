//
//  PaginableBaseTableDataDisplayManager.swift
//  ReactiveDataDisplayManager
//
//  Created by Ivan Smetanin on 27/05/2018.
//  Copyright © 2018 Александр Кравченков. All rights reserved.
//

import Foundation

/// Contains extension of BaseTableDataDisplayManager for catching last cell showing event.
open class PaginableBaseTableDataDisplayManager: BaseTableDataDisplayManager {

    /// Called if table shows last cell
    public var lastCellShowingEvent = BaseEvent<Void>()

    open override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        super.tableView(tableView, willDisplay: cell, forRowAt: indexPath)

        let lastSectionIndex = self.cellGenerators.count - 1
        let lastCellInLastSectionIndex = self.cellGenerators[lastSectionIndex].count - 1

        let lastCellIndexPath = IndexPath(row: lastCellInLastSectionIndex, section: lastSectionIndex)
        if indexPath == lastCellIndexPath {
            self.lastCellShowingEvent.invoke(with: ())
        }
    }

}
