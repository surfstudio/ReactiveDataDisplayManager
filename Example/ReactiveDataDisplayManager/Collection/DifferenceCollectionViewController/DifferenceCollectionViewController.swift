//
//  DifferenceCollectionViewController.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 14.04.2021.
//
import UIKit
import ReactiveDataDisplayManager

final class DifferenceCollectionViewController: UIViewController {

    typealias DiffableGenerator = DiffableCollectionCellGenerator<TitleCollectionListCell>

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

    @IBOutlet private weak var collectionView: UICollectionView!

    // MARK: - Private Properties

    private lazy var adapter = collectionView.rddm.baseBuilder.build()

    private var generators: [DiffableGenerator] = []

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearch()
        setupBarButtonItem()
        fillAdapter()
    }

}

// MARK: - SearchDelegate

extension DifferenceCollectionViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // apply snapshot
        adapter.reload { adapter in
            // clear existing generators
            adapter.clearCellGenerators()

            // add header with static id
            adapter.addSectionHeaderGenerator(EmptyCollectionHeaderGenerator(uniqueId: Constants.sectionId))

            // add filtered  generators
            adapter.addCellGenerators(filterGenerators(with: searchText))
        }

        // all insert, remove, reload animations will be selected automatically
    }

}

// MARK: - Private Methods

private extension DifferenceCollectionViewController {

    func setupSearch() {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }

    func setupBarButtonItem() {
        let button = UIBarButtonItem(title: "Remove First", style: .plain, target: self, action: #selector(removeFirst))
        navigationItem.rightBarButtonItem = button
    }

    /// This method is used to fill adapter
    func fillAdapter() {

        // apply snapshot
        adapter.reload(with: { adapter in
            generators = makeCellGenerators()

            // add header with static id
            adapter.addSectionHeaderGenerator(EmptyCollectionHeaderGenerator(uniqueId: Constants.sectionId))

            // add generators
            adapter.addCellGenerators(generators)
        })
    }

    // Create cells generators
    func makeCellGenerators() -> [DiffableGenerator] {
        Constants.models.enumerated().map { item in
            TitleCollectionListCell.rddm.diffableGenerator(uniqueId: item.offset, with: item.element)
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

        generators.removeFirst()

        // apply snapshot
        adapter.reload { adapter in
            // clear existing generators
            adapter.clearCellGenerators()

            // add header with static id
            adapter.addSectionHeaderGenerator(EmptyCollectionHeaderGenerator(uniqueId: Constants.sectionId))

            // add generators
            adapter.addCellGenerators(generators)
        }

        // expected remove animation
    }

}
