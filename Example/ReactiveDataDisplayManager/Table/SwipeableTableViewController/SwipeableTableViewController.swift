//
//  SwipeableTableViewController.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 11.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager

final class SwipeableTableViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let models = [String](repeating: "Cell", count: 10)
    }

    // MARK: - IBOutlet

    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Private Properties

    private let swipeActionProvider = SwipeActionProvider()
    private lazy var adapter = tableView.rddm.manualBuilder
        .add(featurePlugin: .swipeActions(swipeProvider: swipeActionProvider))
        .build()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Table with swipeable cells"
        tableView.dragInteractionEnabled = false
        fillAdapter()
    }

}

// MARK: - Private Methods

private extension SwipeableTableViewController {

    /// This method is used to fill adapter
    func fillAdapter() {
        // Create cell generators
        let generators = Constants.models.map { model -> SwipeableTableGenerator in
            let generator = SwipeableTableGenerator(with: model)

            generator.didSwipeEvent += { [weak generator] actionType in
                debugPrint("The action with type \(actionType) was selected from all available generator events \(generator?.actionTypes ?? [])")
            }

            return generator
        }

        // Add generators into adapter
        adapter.addCellGenerators(generators)

        // Tell adapter that we've changed generators
        adapter.forceRefill()
    }

}
