//
//  AlphabeticalTableViewController.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 08.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager

final class AlphabeticalTableViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let alphabets = ["A", "B", "C", "D"]
        static let models = [String](repeating: "Cell", count: 5)
    }

    // MARK: - IBOutlets

    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Private Properties

    private let sectionTitleWrapper = TableSectionTitleWrapper()
    private lazy var adapter = tableView.rddm.manualBuilder
        .add(featurePlugin: .sectionTitleDisplayable(titleWrapper: sectionTitleWrapper))
        .build()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Table with alphabetize sections"
        fillAdapter()
    }

}

// MARK: - Private methods

private extension AlphabeticalTableViewController {

    /// This method is used to fill adapter
    func fillAdapter() {

        // Set array with section titles to wrapper
        sectionTitleWrapper.titles = Constants.alphabets

        // Add generators to adapter
        Constants.alphabets.forEach {
            // Create header generator
            let headerGenerator = TitleHeaderGenerator(model: $0)
            // Add header generator into adapter
            adapter += headerGenerator
            // Add cell generators into adapter
            adapter += makeCellGenerators()
        }

        // Tell adapter that we've changed generators
        adapter => .reload
    }

    // Make cells generators
    func makeCellGenerators() -> [TableCellGenerator] {
        return Constants.models.map { TitleTableViewCell.rddm.baseGenerator(with: $0) }
    }

}
