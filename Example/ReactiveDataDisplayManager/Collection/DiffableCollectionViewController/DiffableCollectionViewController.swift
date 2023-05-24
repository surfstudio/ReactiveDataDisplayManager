//
//  DiffableCollectionViewController.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Никита Коробейников on 16.03.2021.
//
import UIKit
import ReactiveDataDisplayManager
import ReactiveDataComponents

@available(iOS 13.0, *)
final class DiffableCollectionViewController: UIViewController {

    typealias DiffableGenerator = DiffableCollectionCellGenerator<TitleCollectionListCell>

    typealias FirstSection = Section<DiffableGenerator, EmptyCollectionHeaderGenerator, CollectionFooterGenerator>

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

    private lazy var adapter = collectionView.rddm.baseBuilder
        .set(dataSource: { DiffableCollectionDataSource(provider: $0) })
        .build()

    private var generators: [DiffableGenerator] = []

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSearch()
        setupBarButtonItem()
        generators = makeCellGenerators()
        fillAdapter(with: generators)
    }

}

// MARK: - SearchDelegate

@available(iOS 13.0, *)
extension DiffableCollectionViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // show filtered generators
        fillAdapter(with: filterGenerators(with: searchText))
        // all insert, remove, reload animations will be selected automatically
    }

}

// MARK: - Private methods

@available(iOS 13.0, *)
private extension DiffableCollectionViewController {

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
    func fillAdapter(with generators: [DiffableGenerator]) {

        adapter -= .all

        let section = FirstSection(generators: generators,
                                   header: EmptyCollectionHeaderGenerator(uniqueId: Constants.sectionId),
                                   footer: EmptyCollectionFooterGenerator())

        adapter += section.generators * section.header

        // apply snapshot
        adapter => .reload
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

        // remove
        generators.removeFirst()
        // show
        fillAdapter(with: generators)
        // all insert, remove, reload animations will be selected automatically
    }

}
