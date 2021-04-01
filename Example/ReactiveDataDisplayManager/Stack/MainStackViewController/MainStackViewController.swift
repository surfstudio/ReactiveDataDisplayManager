//
//  MainStackViewController.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Dmitry Korolev on 01.04.2021.
//

import UIKit
import ReactiveDataDisplayManager

final class MainStackViewController: UIViewController {

    // MARK: - SegueIdentifiers

    fileprivate enum SegueIdentifier: String {
        case simple
        case unroll
        
    }

    // MARK: - Constants

    private enum Constants {
        static let models: [(title: String, segueId: SegueIdentifier)] = [
            ("Simple stack view", .simple),
            ("Unroll example", .unroll)
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

private extension MainStackViewController {

    /// This method is used to fill adapter
    func fillAdapter() {

        for model in Constants.models {
            // Create generator
            let generator = TitleWithIconTableViewCell.rddm.baseGenerator(with: model.title)

            generator.didSelectEvent += { [weak self] in
                guard let self = self else { return }
                self.performSegue(withIdentifier: model.segueId.rawValue, sender: self.tableView)
            }

            // Add generator to adapter
            ddm.addCellGenerator(generator)
        }

        ddm.forceRefill()
    }

}
