//
//  MovableTableDelegate.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 22.01.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

open class MovableTableDelegate: BaseTableDelegate {

    open override func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        if let generator = manager?.generators[indexPath.section][indexPath.row] as? MovableGenerator {
            return generator.canMove()
        }
        return super.tableView(tableView, canFocusRowAt: indexPath)
    }
}
