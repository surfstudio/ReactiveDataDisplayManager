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
        case diffableTable
        case refreshableTable
        case paginatableTable
        case allPluginsTable
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
            ("table with diffableDataSource", .diffableTable),
            ("table with swipeable cells", .swipeableTable),
            ("table with refresh control", .refreshableTable),
            ("table with pagination", .paginatableTable),
            ("table with all plugins", .allPluginsTable)
        ]
    }

    // MARK: - IBOutlets

    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Private Properties

    private lazy var ddm = tableView.rddm.baseBuilder
        .add(plugin: .selectable())
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
                self?.openScreen(by: model.segueId)
            }

            // Add generator to adapter
            ddm.addCellGenerator(generator)
        }

        ddm.forceRefill()
    }

    func openScreen(by segueId: SegueIdentifier) {
        switch segueId {
        case .diffableTable:
            if #available(iOS 13.0, *) {
                performSegue(withIdentifier: segueId.rawValue, sender: tableView)
            } else {
                showAlert("Available from iOS 13")
            }
        default:
            performSegue(withIdentifier: segueId.rawValue, sender: tableView)
        }
    }

}
