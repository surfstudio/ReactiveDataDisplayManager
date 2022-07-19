//
//  UITableViewSpy.swift
//  ReactiveDataDisplayManagerTests
//
//  Created by Anton Eysner on 08.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

final class UITableViewSpy: UITableView {

    var reloadDataWasCalled = false
    var registerNibWasCalled = false
    var scrollToRowWasCalled = false
    var lastReloadedRows: [IndexPath] = []
    var sectionWasReloaded = false

    override func reloadData() {
        super.reloadData()
        reloadDataWasCalled = true
    }

    override func register(_ nib: UINib?, forCellReuseIdentifier identifier: String) {
        registerNibWasCalled = true
        // don't call super to avoid UI API call
    }

    override func scrollToRow(at indexPath: IndexPath, at scrollPosition: UITableView.ScrollPosition, animated: Bool) {
        scrollToRowWasCalled = true
    }

    // this method not work with base dataSource, use MockDataSource
    override func reloadRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        lastReloadedRows = indexPaths
    }

    // this method not work with custom dataSource, use MockModifier
    override func reloadSections(_ sections: IndexSet, with animation: UITableView.RowAnimation) {
        sectionWasReloaded = true
    }

}
