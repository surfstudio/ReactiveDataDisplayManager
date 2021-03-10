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
                             "Afghanistan",
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

    private var generators: [DiffableCellGenerator] = []

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

        generators = makeCellGenerators()

        // add generators
        adapter.addCellGenerators(generators)

        // apply snapshot
        adapter.forceRefill()
    }

    // Create cells generators
    func makeCellGenerators() -> [DiffableCellGenerator] {
         Constants.models.map { title in
            DiffableCellGenerator(with: title)
         }
    }

    // filter generators
    func filterGenerators(with filter: String) -> [DiffableCellGenerator] {
        guard !filter.isEmpty, !generators.isEmpty else {
            return generators
        }
        return generators.filter { $0.model.starts(with: filter) }
    }

}

// MARK: - SearchDelegate

@available(iOS 13.0, *)
extension DiffableTableViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        // clear existing generators
        adapter.clearCellGenerators()

        // add filtered  generators
        adapter.addCellGenerators(filterGenerators(with: searchText))

        // apply snapshot
        adapter.forceRefill()

        // all insert, remove, reload animations will be selected automatically

    }

}
