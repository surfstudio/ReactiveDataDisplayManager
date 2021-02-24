//
//  ViewController.swift
//  ReactiveDataDisplayManager
//
//  Created by Ivan Smetanin on 18/12/2017.
//  Copyright © 2017 Alexander Kravchenkov. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager

final class MainTableViewController: UIViewController {

    // MARK: - SegueIdentifiers

    fileprivate enum SegueIdentifier: String {
        case prefetchingTable
        case imageTable
        case foldableCellTable
        case gravityTable
        case movableTable
        case alphabetizeSectionsTable
        case sectionTitlesTable
        case swipeableTable
    }

    // MARK: - Constants

    private enum Constants {
        static let models: [(title: String, segueId: SegueIdentifier)] = [
            ("gallery without prefetching", .imageTable),
            ("gallery with prefetching", .prefetchingTable),
            ("table with foldable cell", .foldableCellTable),
            ("gravity table with foldable cell", .gravityTable),
            ("table with movable cell", .movableTable),
            ("table with alphabetize sections", .alphabetizeSectionsTable),
            ("table with sections titles", .sectionTitlesTable),
            ("table with swipeable cells", .swipeableTable)
        ]
    }

    // MARK: - IBOutlets

    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Private Properties

    private lazy var adapter = tableView.rddm.baseBuilder
        .add(plugin: TableSelectablePlugin())
        .build()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        fillAdapter()
    }

}

// MARK: - Private methods

private extension MainTableViewController {

    /// This method is used to fill adapter
    func fillAdapter() {
        for model in Constants.models {
            // Create generator
            let generator = TitleTableViewCell.rddm.baseGenerator(with: model.title)
            
            generator.didSelectEvent += { [weak self] in
                guard let self = self else { return }
                self.performSegue(withIdentifier: model.segueId.rawValue, sender: self.tableView)
            }

            // Add generator to adapter
            adapter.addCellGenerator(generator)
        }

        // Tell adapter that we've changed generators
        adapter.forceRefill()
    }

}
