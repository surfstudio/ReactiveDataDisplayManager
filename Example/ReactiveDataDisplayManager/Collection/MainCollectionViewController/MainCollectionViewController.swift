//
//  MainCollectionViewController.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Vadim Tikhonov on 09.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager

final class MainCollectionViewController: UIViewController {

    // MARK: - SegueIdentifiers

    fileprivate enum SegueIdentifier: String {
        case baseCollection
        case listAppearances
    }

    // MARK: - Constants

    private enum Constants {
        static let models: [(title: String, segueId: SegueIdentifier)] = [
            ("Base collection view", .baseCollection),
            ("List Appearances", .listAppearances)
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

private extension MainCollectionViewController {

    /// This method is used to fill adapter
    func fillAdapter() {
        for model in Constants.models {
            // Create generator
            let generator = TitleTableGenerator(model: model.title)

            generator.didSelectEvent += { [weak self] in
                guard let self = self else { return }

                switch model.segueId {
                case .listAppearances:
                    if #available(iOS 14.0, *) {
                        self.performSegue(withIdentifier: model.segueId.rawValue, sender: self.tableView)
                    } else {
                        self.showAlert("Available from 14 IOS")
                    }
                default:
                    self.performSegue(withIdentifier: model.segueId.rawValue, sender: self.tableView)
                }
            }

            // Add generator to adapter
            adapter.addCellGenerator(generator)
        }

        // Tell adapter that we've changed generators
        adapter.forceRefill()
    }

    func showAlert(_ message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }

}
