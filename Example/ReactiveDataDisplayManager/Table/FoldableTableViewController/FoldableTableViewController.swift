//
//  FoldableTableViewController.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 01.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager

final class FoldableTableViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let titleForRegularCell = "Regular cell with text"
        static let titleForSubcells = ["First subcell", "Second subcell"]
    }

    // MARK: - IBOutlet

    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Private Properties

    private lazy var adapter = tableView.rddm.baseBuilder
        .add(plugin: .foldable())
        .build()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.accessibilityIdentifier = "FoldableTableViewController"
        fillAdapter()
    }

}

// MARK: - Private Methods

private extension FoldableTableViewController {

    /// This method is used to fill adapter
    func fillAdapter() {
        // Add regular cell generators with titles
        adapter.addCellGenerators(makeRegularCellWithTitlesGenerators())

        // Add foldable cell generator to adapter
        adapter.addCellGenerator(makeFoldableCellGenerator(id: "1"))

        // Add regular cell generators with titles
        adapter.addCellGenerators(makeRegularCellWithTitlesGenerators())

        // Add foldable cell generator to adapter
        adapter.addCellGenerator(makeFoldableCellGenerator(id: "2"))

        // Tell adapter that we've changed generators
        adapter.forceRefill()
    }

    func makeRegularCellWithTitlesGenerators() -> [TableCellGenerator] {
        var generators = [TableCellGenerator]()
        for _ in 0...3 {
            generators.append(TitleTableViewCell.rddm.baseGenerator(with: Constants.titleForRegularCell))
        }
        return generators
    }

    func makeFoldableCellGenerator(id: String) -> FoldableCellGenerator {
        // Create foldable generator
        let generator = FoldableCellGenerator(with: .init(title: id, isExpanded: false))

        // Create and add child generators
        generator.childGenerators = Constants.titleForSubcells.map { TitleTableViewCell.rddm.baseGenerator(with: $0) }
        return generator
    }

}
