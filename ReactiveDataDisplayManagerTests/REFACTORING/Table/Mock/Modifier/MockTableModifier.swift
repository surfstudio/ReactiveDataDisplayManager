//
//  MockTableModifier.swift
//  ReactiveDataDisplayManager
//
//  Created by porohov on 21.06.2022.
//

import UIKit

@testable import ReactiveDataDisplayManager

final class MockTableModifier: Modifier<UITableView, UITableView.RowAnimation> {

    // MARK: - Properties

    var lastReloadedRows: [IndexPath] = []
    var sectionWasReloaded = false

    // MARK: - Modifier

    override func reloadSections(at indexPaths: IndexSet, with updateAnimation: UITableView.RowAnimation) {
        sectionWasReloaded = true
    }

    override func reloadRows(at indexPaths: [IndexPath], with updateAnimation: UITableView.RowAnimation) {
        lastReloadedRows = indexPaths
    }

}
