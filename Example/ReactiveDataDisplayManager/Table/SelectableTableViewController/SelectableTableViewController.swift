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
        static let cellCount = Array(1...10)
        static let multiple = "Multiple mode"
        static let standart = "Single mode"
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
        tableView.accessibilityIdentifier = "Table_with_selectable_cells"
        fillAdapter()
        updateBarButtonItem(with: Constants.standart)
    }

}

// MARK: - Private Methods

private extension SelectableTableViewController {

    /// This method is used to fill adapter
    func fillAdapter() {
        // Create cell generators
        let generators = Constants.cellCount.map { cellCount -> TableCellGenerator in
            let titleCell = "Cell \(cellCount)"
            let generator = BaseCellGenerator<TitleTableViewCell>(with: titleCell)
            generator.didSelectEvent += {
                print("Select \(titleCell)")
            }

            generator.didDeselectEvent += {
                print("Deselect \(titleCell)")
            }

            return generator
        }

        // Add generators into adapter
        adapter.addCellGenerators(generators)

        // Tell adapter that we've changed generators
        adapter.forceRefill()
    }

    func updateBarButtonItem(with title: String) {
        let button = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(toggleAllowsMultiple))
        navigationItem.rightBarButtonItem = button
    }

    @objc
    func toggleAllowsMultiple() {
        adapter.generators.forEach { $0.forEach { ($0 as? SelectableItem)?.isNeedDeselect.toggle() } }
        adapter.view.allowsMultipleSelection.toggle()
        updateBarButtonItem(with: tableView.allowsMultipleSelection ? Constants.multiple : Constants.standart)
    }

}
