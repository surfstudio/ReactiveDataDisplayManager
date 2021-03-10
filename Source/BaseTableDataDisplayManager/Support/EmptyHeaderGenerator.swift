//
//  EmptyHeaderGenerator.swift
//  ReactiveDataDisplayManager
//
//  Created by Ivan Smetanin on 27/05/2018.
//  Copyright © 2018 Александр Кравченков. All rights reserved.
//

import UIKit

public class EmptyTableHeaderGenerator: TableHeaderGenerator {

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

extension EmptyTableHeaderGenerator: DiffableItemSource {

    public var item: DiffableItem {
        DiffableItem(id: uuid, state: .init("RDDM.Diffable.EmptySection"))
    }

}
