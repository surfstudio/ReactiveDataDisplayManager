//
//  ExtendableBaseTableDataDisplayManager.swift
//  ReactiveDataDisplayManager
//
//  Created by Ivan Smetanin on 27/05/2018.
//  Copyright © 2018 Александр Кравченков. All rights reserved.
//

import Foundation

/// Contains extension of BaseTableDataDisplayManager for expand and collapse section headers.
open class ExtendableBaseTableDataDisplayManager: BaseTableDataDisplayManager {

    open override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeaderGenerators.isEmpty ? 1 : sectionHeaderGenerators.count
    }

}
