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
        static let models = Array(repeating: "movable cell", count: 5)
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
        tableView.accessibilityIdentifier = "Table_with_movable_cell"
        tableView.dragInteractionEnabled = false
        fillAdapter()
    }

}

// MARK: - Private methods

private extension MovableTableViewController {

    /// This method is used to fill adapter
    func fillAdapter() {
        // Add generator to adapter
        adapter += TitleHeaderGenerator(model: Constants.titleForSection + " 1")
        adapter += makeMovableCellGenerators(for: Array(1...5))
        adapter += TitleHeaderGenerator(model: Constants.titleForSection + " 2")
        adapter += makeMovableCellGenerators(for: Array(1...5))

        // Tell adapter that we've changed generators
        adapter => .reload
        tableView.setEditing(true, animated: true)
    }

    // Create cells generators
    func makeMovableCellGenerators(for range: [Int]) -> [MovableCellGenerator] {
        var generators = [MovableCellGenerator]()

        for index in range {
            let generator = MovableCellGenerator(with: "Cell: \(index)")
            generators.append(generator)
        }

        return generators
    }

}
