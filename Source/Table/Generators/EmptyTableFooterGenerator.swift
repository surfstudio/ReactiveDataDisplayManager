//
//  EmptyTableFooterGenerator.swift
//  Pods
//
//  Created by porohov on 02.12.2021.
//

import UIKit

public class EmptyTableFooterGenerator: TableFooterGenerator {

    open override func generate() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }

    open override func height(_ tableView: UITableView, forSection section: Int) -> CGFloat {
        return 0.01
    }

}

// MARK: - DiffableItemSource

extension EmptyTableFooterGenerator: DiffableItemSource {

    public var diffableItem: DiffableItem {
        DiffableItem(id: id, state: .init("RDDM.Diffable.EmptySection"))
    }

}
