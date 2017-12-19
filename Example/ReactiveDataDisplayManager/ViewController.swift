//
//  ViewController.swift
//  ReactiveDataDisplayManager
//
//  Created by Ivan Smetanin on 18/12/2017.
//  Copyright © 2017 Alexander Kravchenkov. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager

class ViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Properties

    private lazy var adapter = BaseTableDataDisplayManager()
    private lazy var titles: [String] = ["One", "Two", "Three", "Four"]

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAdapter()
        fillAdapter()
    }

    // MARK: - Private methods

    /// This method is used to configure table adapter and set table delegate and data source
    private func configureAdapter() {
        adapter.setTableView(tableView)
        tableView.delegate = adapter
        tableView.dataSource = adapter
    }

    /// This method is used to fill adapter
    private func fillAdapter() {
        for title in titles {
            // Create generator
            let generator = TitleGenerator(model: title)
            generator.didSelectEvent += {
                debugPrint("\(title) selected")
            }
            // Add generator to adapter
            adapter.addCellGenerator(generator)
        }

        // Tell adapter that we've changed generators
        adapter.didRefill()
    }
}

