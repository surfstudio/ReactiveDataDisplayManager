//
//  HighlightableTableViewController.swift
//  ReactiveDataDisplayManagerExample_iOS
//
//  Created by porohov on 14.06.2022.
//
import UIKit
import ReactiveDataDisplayManager

final class HighlightableTableViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let models = [String](repeating: "Cell", count: 10)
        static let standart = "Single mode"
        static let multiple = "Multiple mode"
    }

    // MARK: - IBOutlet

    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Private Properties

    private lazy var adapter = tableView.rddm.manualBuilder
        .add(plugin: .highlightable())
        .build()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Higlighted cells"
        fillAdapter()
        updateBarButtonItem(with: Constants.standart)
    }

}

// MARK: - Private Methods

private extension HighlightableTableViewController {

    /// This method is used to fill adapter
    func fillAdapter() {
        // Create cell generators
        let generators = Constants.models.map { model -> TableCellGenerator in
            HighlightableTableCell.rddm.baseGenerator(with: model)
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
