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
        case differenceTable
        case dragAndDroppableTable
        case selectableTable
        case highlightableTable
    }

    // MARK: - Constants

    private enum Constants {
        static let models: [(title: String, segueId: SegueIdentifier)] = [
            ("Gallery without prefetching", .imageTable),
            ("Gallery with prefetching", .prefetchingTable),
            ("foldable cell", .foldableCellTable),
            ("Gravity foldable cell", .gravityTable),
            ("movable cell", .movableTable),
            ("alphabetize sections", .alphabetizeSectionsTable),
            ("sections titles", .sectionTitlesTable),
            ("diffableDataSource", .diffableTable),
            ("swipeable cells", .swipeableTable),
            ("refresh control", .refreshableTable),
            ("pagination", .paginatableTable),
            ("all plugins", .allPluginsTable),
            ("DifferenceKit", .differenceTable),
            ("drag and drop cells", .dragAndDroppableTable),
            ("selectable cells", .selectableTable),
            ("highlightable cells", .highlightableTable)
        ]
    }

    // MARK: - IBOutlets

    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Private Properties

    private lazy var ddm = tableView.rddm.baseBuilder
        .add(plugin: .selectable())
        .add(plugin: .accessibility())
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
            let generator = TitleWithIconTableViewCell.rddm.baseGenerator(with: model.title)

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
            if #available(iOS 13.0, tvOS 13.0, *) {
                performSegue(withIdentifier: segueId.rawValue, sender: tableView)
            } else {
                showAlert("Available from iOS 13")
            }
        default:
            performSegue(withIdentifier: segueId.rawValue, sender: tableView)
        }
    }

}
