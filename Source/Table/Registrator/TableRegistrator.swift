//
//  TableRegistrator.swift
//  Pods
//
//  Created by Никита Коробейников on 14.04.2022.
//

import UIKit

public class TableRegistrator: Registrator<UITableView> {

    public override func register(item: RegisterableItem, with view: UITableView) {
        switch item {
        case let cell as TableCellRegisterableItem:
            cell.registerCell(in: view)
        case let header as TableHeaderRegisterableItem:
            header.registerHeader(in: view)
        case let footer as TableFooterRegisterableItem:
            footer.registerFooter(in: view)
        default:
            break
        }
    }

}
