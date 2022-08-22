//
//  UITableViewSpy.swift
//  ReactiveDataDisplayManagerTests
//
//  Created by Anton Eysner on 08.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

final class SpyUITableView: UITableView {

    var reloadDataWasCalled = false
    var registerWasCalled = false
    var scrollToRowWasCalled = false
    var lastReloadedRows: [IndexPath] = []
    var sectionWasReloaded = false

    override func reloadData() {
        super.reloadData()
        reloadDataWasCalled = true
    }

    override func register(_ cellClass: AnyClass?, forCellReuseIdentifier identifier: String) {
        super.register(cellClass, forCellReuseIdentifier: identifier)
        registerWasCalled = true
    }

    override func register(_ nib: UINib?, forCellReuseIdentifier identifier: String) {
        super.register(nib, forCellReuseIdentifier: identifier)
        registerWasCalled = true
    }

    override func scrollToRow(at indexPath: IndexPath, at scrollPosition: UITableView.ScrollPosition, animated: Bool) {
        super.scrollToRow(at: indexPath, at: scrollPosition, animated: animated)
        scrollToRowWasCalled = true
    }

    // this method not work with base dataSource, use MockDataSource
    override func reloadRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        super.reloadRows(at: indexPaths, with: animation)
        lastReloadedRows = indexPaths
    }

    // this method not work with custom dataSource, use MockModifier
    override func reloadSections(_ sections: IndexSet, with animation: UITableView.RowAnimation) {
        super.reloadSections(sections, with: animation)
        sectionWasReloaded = true
    }

}
