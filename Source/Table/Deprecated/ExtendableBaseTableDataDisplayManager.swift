//
//  ExtendableBaseTableDataDisplayManager.swift
//  ReactiveDataDisplayManager
//
//  Created by Ivan Smetanin on 27/05/2018.
//  Copyright © 2018 Александр Кравченков. All rights reserved.
//

import UIKit

/// Contains extension of BaseTableDataDisplayManager for expand and collapse section headers.
@available(*, deprecated, message: "Use any BaseTableManager with custom BaseTableDelegate instead")
open class ExtendableBaseTableDataDisplayManager: BaseTableDataDisplayManager {

    open override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeaderGenerators.isEmpty ? 1 : sectionHeaderGenerators.count
    }

}
