//
//  DiffableTableViewController.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 04.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager

final class DiffableTableViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let titleForSection = "Section"
        static let models = [String](repeating: "Cell", count: 5)
    }

    // MARK: - IBOutlets

    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Private Properties

    @available(iOS 13.0, *)
    private lazy var adapter = tableView.rddm.diffableBuilder.build()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Table with diffableDataSource"

        if #available(iOS 13.0, *) {
            fillAdapter()
        }
    }

}

// MARK: - Private methods

private extension DiffableTableViewController {

    /// This method is used to fill adapter
    @available(iOS 13.0, *)
    func fillAdapter() {
        // Add generator to adapter
        adapter.addCellGenerator(DiffableCellGenerator(model: Constants.models[0]))

        // Add header generator
        adapter.addSectionHeaderGenerator(TitleHeaderGenerator(model: Constants.titleForSection))

        // Add generator to adapter
        adapter.addCellGenerators(makeCellGenerators())

        adapter.apply()
    }

    // Create cells generators
    func makeCellGenerators() -> [DiffableCellGenerator] {
        var generators = [DiffableCellGenerator]()
        for (index, title) in Constants.models.enumerated() {
            generators.append(DiffableCellGenerator(model: title + " \(index)"))
        }

        return generators
    }

}
