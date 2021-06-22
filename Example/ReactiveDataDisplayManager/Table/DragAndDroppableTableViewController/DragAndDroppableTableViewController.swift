//
//  DragAndDroppableTableViewController.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 18.02.2021.
//

import UIKit
import ReactiveDataDisplayManager

final class DragAndDroppableTableViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let titleForSection = "Section"
    }

    // MARK: - IBOutlets

    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Private Properties

    private lazy var adapter = tableView.rddm.manualBuilder
        .add(featurePlugin: .dragAndDroppable())
        .build()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "table with drag'n'drop cell"

        tableView.dragInteractionEnabled = true

        fillAdapter()
    }

}

// MARK: - Private methods

private extension DragAndDroppableTableViewController {

    /// This method is used to fill adapter
    func fillAdapter() {
        // Add generator to adapter
        adapter.addSectionHeaderGenerator(TitleHeaderGenerator(model: Constants.titleForSection))
        adapter.addCellGenerators(makeCellGenerators())

        // Tell adapter that we've changed generators
        adapter.forceRefill()
    }

    // Create cells generators
    func makeCellGenerators() -> [TableCellGenerator] {
        var generators = [TableCellGenerator]()

        for index in 0...10 {
            let generator = DragAndDroppableCellGenerator(with: "Cell: \(index)")
            generators.append(generator)
        }

        return generators
    }

}
