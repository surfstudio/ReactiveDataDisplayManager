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
        static let models = ["Afghanistan",
                             "Albania",
                             "Algeria",
                             "Andorra",
                             "Angola",
                             "Antigua and Barbuda",
                             "Argentina",
                             "Armenia",
                             "Australia",
                             "Austria",
                             "Azerbaijan",
                             "Bahamas",
                             "Bahrain",
                             "Bangladesh",
                             "Barbados",
                             "Belarus"]
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

        setupSearch()
        fillAdapter()
    }

}

// MARK: - Private methods

@available(iOS 13.0, *)
private extension DiffableTableViewController {

    func setupSearch() {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }

    /// This method is used to fill adapter
    func fillAdapter() {
        // Add generator to adapter
//        adapter.addCellGenerator(DiffableCellGenerator(with: Constants.models[0]))

        // Add header generator
//        adapter.addSectionHeaderGenerator(TitleHeaderGenerator(model: Constants.titleForSection))

        // Add generator to adapter
        adapter.addCellGenerators(makeCellGenerators())

        // Tell adapter that we've changed generators and need updates the UI to reflect the state of the data
        adapter.forceRefill()
    }

    // Create cells generators
    func makeCellGenerators(with filter: String? = nil) -> [DiffableCellGenerator] {
        guard let filter = filter, !filter.isEmpty else {
            return Constants.models.map { title in
                DiffableCellGenerator(with: title)
            }
        }
        return Constants.models.filter { $0.starts(with: filter) }
            .map { title in
                DiffableCellGenerator(with: title)
            }

    }

}

// MARK: - SearchDelegate

@available(iOS 13.0, *)
extension DiffableTableViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        adapter.clearCellGenerators()

        adapter.addCellGenerators(makeCellGenerators(with: searchText))

        adapter.forceRefill()

    }

}
