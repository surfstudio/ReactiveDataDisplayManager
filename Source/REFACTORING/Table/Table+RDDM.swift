//
//  Table+RDDM.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 21.01.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

extension UITableView: DataDisplayCompatible {}

public extension DataDisplayWrapper where Base: UITableView {

    /// Builder of `BaseTableManager`
    var baseBuilder: TableBuilder<BaseTableManager> {
        TableBuilder(view: base, manager: BaseTableManager())
    }

    /// Builder of `ManualTableManager`
    var manualBuilder: TableBuilder<ManualTableManager> {
        TableBuilder(view: base, manager: ManualTableManager())
    }

    /// Builder of `GravityTableManager`
    var gravityBuilder: TableBuilder<GravityTableManager> {
        TableBuilder(view: base, manager: GravityTableManager())
    }

}
