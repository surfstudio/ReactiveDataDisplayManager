//
//  ViewController.swift
//  ReactiveDataDisplayManager
//
//  Created by Ivan Smetanin on 18/12/2017.
//  Copyright © 2017 Alexander Kravchenkov. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager

final class MainTableViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Private Properties

    private lazy var adapter = tableView.rddm.baseBuilder
        .add(plugin: TableSelectablePlugin())
        .build()
    private lazy var titles: [String] = ["One", "Two", "Three", "Four"]

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        fillAdapter()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }

}

// MARK: - Private methods

private extension MainTableViewController {

    /// This method is used to fill adapter
    func fillAdapter() {
        for title in titles {
            // Create generator
            let generator = TitleTableGenerator(model: title)
            generator.didSelectEvent += {
                debugPrint("\(title) selected")
                self.openPrefetchingTableViewController()
            }
            // Add generator to adapter
            adapter.addCellGenerator(generator)
        }

        // Tell adapter that we've changed generators
        adapter.forceRefill()
    }

    func openPrefetchingTableViewController() {
        let controller = PrefetchingTableViewController()
        navigationController?.pushViewController(controller, animated: true)
    }

}
