// 
//  MainTableController.swift
//  ReactiveDataDisplayManagerExample_tvOS
//
//  Created by Olesya Tranina on 26.07.2021.
//  
//

import UIKit
import ReactiveDataDisplayManager

final class MainTableController: UIViewController {

    // MARK: - SegueIdentifiers

    fileprivate enum SegueIdentifier: String {
        case gallery
        case collectionDefaultBehavoir
        case table
    }

    // MARK: - Constants

    private enum Constants {
        static let models: [(title: String, segueId: SegueIdentifier)] = [
            ("GalleryController", .gallery),
            ("CollectionDefaultBehavoirController", .collectionDefaultBehavoir),
            ("TableController", .table)
        ]
    }

    // MARK: - IBOutlets

    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Private Properties

    private lazy var ddm = tableView.rddm.baseBuilder
        .add(featurePlugin: .focusable())
        .add(plugin: .selectable())
        .build()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        fillAdapter()
    }

}

// MARK: - Private methods

private extension MainTableController {

    /// This method is used to fill adapter
    func fillAdapter() {

        for model in Constants.models {
            // Create generator
            let generator = TitleTableViewGenerator(with: .init(title: model.title))

            generator.didSelectEvent += { [weak self] in
                self?.openScreen(by: model.segueId)
            }

            // Add generator to adapter
            ddm.addCellGenerator(generator)
        }

        ddm.forceRefill()
    }

    func openScreen(by segueId: SegueIdentifier) {
        performSegue(withIdentifier: segueId.rawValue, sender: tableView)
    }

}
