//
//  MovableTableViewController.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 02.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager

final class MovableTableViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let titleForSection = "Section"
        static let models = [String](repeating: "movable cell", count: 5)
    }

    // MARK: - IBOutlets

    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Private Properties

    private lazy var adapter = tableView.rddm.manualBuilder
        .add(featurePlugin: .movable())
        .build()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "table with movable cell"
        fillAdapter()
    }

}

// MARK: - Private methods

private extension MovableTableViewController {

    /// This method is used to fill adapter
    func fillAdapter() {
        // Add generator to adapter
        adapter.addSectionHeaderGenerator(TitleHeaderGenerator(model: Constants.titleForSection))
        adapter.addCellGenerators(makeMovableCellGenerators())
        adapter.addSectionHeaderGenerator(TitleHeaderGenerator(model: Constants.titleForSection))
        adapter.addCellGenerators(makeMovableCellGenerators())

        // Tell adapter that we've changed generators
        adapter.forceRefill()
        tableView.setEditing(true, animated: true)
    }

    // Create cells generators
    func makeMovableCellGenerators() -> [MovableCellGenerator] {
        return Constants.models.map { MovableCellGenerator(with: $0) }
    }

}
