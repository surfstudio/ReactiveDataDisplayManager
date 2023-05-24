//
//  DiffableTableViewController.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 04.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager
import ReactiveDataComponents

@available(iOS 13.0, *)
final class DiffableTableViewController: UIViewController {

    typealias DiffableGenerator = DiffableCellGenerator<TitleTableViewCell>

    typealias DiffableSection = Section<DiffableGenerator, EmptyTableHeaderGenerator, TableFooterGenerator>

    // MARK: - Constants

    private enum Constants {
        static let sectionId = "Section"
        static let models = [
            "Afghanistan",
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
            "Belarus"
        ]
    }

    // MARK: - IBOutlets

    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Private Properties

    private lazy var adapter = tableView.rddm.baseBuilder
        .set(dataSource: { DiffableTableDataSource(provider: $0) })
        .build()

    private var generators: [DiffableGenerator] = []

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Table with diffableDataSource"

        setupSearch()
        setupBarButtonItem()
        generators = makeCellGenerators()
        fillAdapter(with: generators)
    }

}

// MARK: - SearchDelegate

@available(iOS 13.0, *)
extension DiffableTableViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // show filtered generators
        fillAdapter(with: filterGenerators(with: searchText))
        // all insert, remove, reload animations will be selected automatically
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

    func setupBarButtonItem() {
        let button = UIBarButtonItem(title: "Remove First", style: .plain, target: self, action: #selector(removeFirst))
        navigationItem.rightBarButtonItem = button
    }

    func DiffableSections(
        @GeneratorsBuilder<DiffableSection>_ content: () -> [DiffableSection]
    ) -> [DiffableSection] {
        content()
    }

    /// This method is used to fill adapter
    func fillAdapter(with generators: [DiffableGenerator]) {

        adapter -= .all

        let section = DiffableSection(
            generators: generators,
            header: EmptyTableHeaderGenerator(uniqueId: Constants.sectionId),
            footer: TableFooterGenerator()
        ).decorate(with: .space(model: .init(height: 16, color: .rddm)),
                   at: .end,
                   and: .each)

        adapter += section.generators * section.header

        // apply snapshot
        adapter => .reload
    }

    // Create cells generators
    func makeCellGenerators() -> [DiffableGenerator] {
        Constants.models.enumerated().map { item in
            TitleTableViewCell.rddm.diffableGenerator(uniqueId: item.offset, with: item.element)
        }
    }

    // filter generators
    func filterGenerators(with filter: String) -> [DiffableGenerator] {
        guard !filter.isEmpty, !generators.isEmpty else {
            return generators
        }
        return generators.filter { $0.model.starts(with: filter) }
    }

    @objc
    func removeFirst() {
        guard !generators.isEmpty else { return }

        // remove
        generators.removeFirst()
        // show
        fillAdapter(with: generators)
        // all insert, remove, reload animations will be selected automatically
    }

}
