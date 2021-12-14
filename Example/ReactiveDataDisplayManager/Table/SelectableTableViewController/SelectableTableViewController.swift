//
//  SelectableTableViewController.swift
//  ReactiveDataDisplayManagerExample_iOS
//
//  Created by porohov on 14.12.2021.
//

import UIKit
import ReactiveDataDisplayManager

final class SelectableTableViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let models = [String](repeating: "Cell", count: 10)
        static let multiple = "Multiple"
        static let standart = "Standart"
    }

    // MARK: - IBOutlet

    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Private Properties

    private lazy var adapter = tableView.rddm.manualBuilder
        .add(plugin: .selectable())
        .build()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Table with selectable cells"
        fillAdapter()
        updateBarButtonItem(with: Constants.multiple)
    }

}

// MARK: - Private Methods

private extension SelectableTableViewController {

    /// This method is used to fill adapter
    func fillAdapter() {
        // Create cell generators
        let generators = Constants.models.map { model -> SwipeableTableGenerator in
            let generator = SwipeableTableGenerator(with: model)
            generator.didSelectEvent += {
                print("Select")
            }

            generator.didDeselectEvent += {
                print("Deselect")
            }

            return generator
        }

        // Add generators into adapter
        adapter.addCellGenerators(generators)

        // Tell adapter that we've changed generators
        adapter.forceRefill()
    }

    func updateBarButtonItem(with title: String) {
        let button = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(changeAllowsMultiple))
        navigationItem.rightBarButtonItem = button
    }

    @objc
    func changeAllowsMultiple() {
        adapter.generators.forEach { $0.forEach { ($0 as? SelectableItem)?.isNeedDeselect.toggle() } }
        adapter.view.allowsMultipleSelection.toggle()
        updateBarButtonItem(with: tableView.allowsMultipleSelection ? Constants.standart : Constants.multiple)
    }

}
