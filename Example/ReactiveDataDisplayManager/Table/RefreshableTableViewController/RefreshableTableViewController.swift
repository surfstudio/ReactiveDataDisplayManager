//
//  RefreshableTableViewController.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Никита Коробейников on 03.03.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager

final class RefreshableTableViewController: UIViewController {

    // MARK: - IBOutlet

    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Private Properties

    private var refreshControl: UIRefreshControl {
        let refreshControl = UIRefreshControl()
        refreshControl.isAccessibilityElement = true
        refreshControl.accessibilityIdentifier = "RefreshableTableViewController_RefreshControl"
        return refreshControl
    }

    private lazy var adapter = tableView.rddm.baseBuilder
        .add(plugin: .refreshable(refreshControl: refreshControl, output: self))
        .add(plugin: .accessibility())
        .build()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "refresh control"
        tableView.accessibilityIdentifier = "Table_with_refresh_control"
        fillAdapter()
    }

}

// MARK: - Private Methods

private extension RefreshableTableViewController {

    /// This method is used to fill adapter
    func fillAdapter() {

        adapter -= .all

        for id in 1...4 {
            adapter += makeGenerator(name: "Cell", id: id)
		}

        adapter => .reload
    }

    func makeGenerator(name: String, id: Int) -> TableCellGenerator {
        TitleTableViewCell.rddm.baseGenerator(with: name + " \(id)")
    }

}

// MARK: - RefreshableOutput

extension RefreshableTableViewController: RefreshableOutput {

    func refreshContent(with input: RefreshableInput) {
        delay(.now() + .seconds(3)) { [weak self, weak input] in

            guard let adapter = self?.adapter else {
                return
            }

            adapter -= .all

	        for id in 1...4 {
				if let generator = self?.makeGenerator(name: "Refreshing", id: id) {
                    self?.adapter += generator
                }
			}

        	adapter => .reload

            input?.endRefreshing()
        }
    }

}
