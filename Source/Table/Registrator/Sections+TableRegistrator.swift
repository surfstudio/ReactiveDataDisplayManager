//
//  Sections+TableRegistrator.swift
//  Pods
//
//  Created by Никита Коробейников on 14.04.2022.
//

import UIKit

extension Array where Element == Section<TableCellGenerator, TableHeaderGenerator, TableFooterGenerator> {

    func registerAllIfNeeded(with view: UITableView, using registrator: Registrator<UITableView>) {
        forEach { section in
            registrator.registerIfNeeded(item: section.header, with: view)
            registrator.registerIfNeeded(item: section.footer, with: view)
            section.generators.forEach {
                registrator.registerIfNeeded(item: $0, with: view)
            }
        }
    }

}
