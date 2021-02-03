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
        .add(plugin: TableFoldablePlugin())
        .build()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
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
        adapter.addCellGenerator(makeFoldableCellGenerator())

        // Add regular cell generators with titles
        adapter.addCellGenerators(makeRegularCellWithTitlesGenerators())

        // Add foldable cell generator to adapter
        adapter.addCellGenerator(makeFoldableCellGenerator())

        // Tell adapter that we've changed generators
        adapter.forceRefill()
    }
    
    func makeRegularCellWithTitlesGenerators() -> [TitleTableGenerator] {
        var generators = [TitleTableGenerator]()
        for _ in 0...3 {
            generators.append(TitleTableGenerator(model: Constants.titleForRegularCell))
        }
        return generators
    }

    func makeFoldableCellGenerator() -> FoldableCellGenerator {
        // Create foldable generator
        let generator = FoldableCellGenerator()

        // Create and add child generators
        generator.childGenerators = Constants.titleForSubcells.map { TitleTableGenerator(model: $0) }
        return generator
    }

}
