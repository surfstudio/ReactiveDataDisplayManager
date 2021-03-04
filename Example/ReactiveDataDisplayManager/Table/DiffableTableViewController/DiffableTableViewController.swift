//
//  DiffableTableViewController.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 04.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager

@available(iOS 13.0, *)
final class DiffableTableViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let titleForSection = "Section"
        static let models = [String](repeating: "Cell", count: 5)
    }

    // MARK: - IBOutlets

    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Private Properties

    private lazy var adapter = tableView.rddm.manualBuilder
        .set(dataSource: { DiffableTableDataSource(provider: $0) })
        .build()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Table with diffableDataSource"

        fillAdapter()
    }

}

// MARK: - Private methods

@available(iOS 13.0, *)
private extension DiffableTableViewController {

    /// This method is used to fill adapter
    func fillAdapter() {
        // Add generator to adapter
        adapter.addCellGenerator(DiffableCellGenerator(model: Constants.models[0]))

        // Add header generator
        adapter.addSectionHeaderGenerator(TitleHeaderGenerator(model: Constants.titleForSection))

        // Add generator to adapter
        adapter.addCellGenerators(makeCellGenerators())

        // Tell adapter that we've changed generators and need updates the UI to reflect the state of the data
        adapter.forceRefill()
    }

    // Create cells generators
    func makeCellGenerators() -> [DiffableCellGenerator] {
        return Constants.models.enumerated().map { index, title in
            DiffableCellGenerator(model: title + " \(index)")
        }
    }

}
