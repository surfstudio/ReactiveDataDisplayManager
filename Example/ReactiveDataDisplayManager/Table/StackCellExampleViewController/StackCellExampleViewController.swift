//
//  StackCellExampleViewController.swift
//  ReactiveDataDisplayManagerExample_iOS
//
//  Created by Konstantin Porokhov on 29.06.2023.
//

import UIKit
import ReactiveDataComponents
import ReactiveDataDisplayManager

final class StackCellExampleViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let cellVerticalCount = Array(1...10)
        static let cellHorizontalCount = Array(1...2)
    }

    // MARK: - IBOutlet

    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Private Properties

    private lazy var adapter = tableView.rddm.manualBuilder
        .add(plugin: .selectable())
        .add(plugin: .highlightable())
        .build()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Stack cell example view controller"
        tableView.accessibilityIdentifier = "Stack_Cell_Example_View_Controller"
        fillAdapter()
    }

}

// MARK: - Private Methods

private extension StackCellExampleViewController {

    /// This method is used to fill adapter
    func fillAdapter() {

        // Create vertical cell generators
        let verticalGenerators = VerticalTableStack {
            TitleTableViewCell.build(with: "Текст 1")
            TitleTableViewCell.build(with: "Текст 2")
            HorizontalTableStack {
                TitleTableViewCell.build(with: "Текст 4")
                TitleTableViewCell.build(with: "Текст 5")
            }
            TitleTableViewCell.build(with: "Текст 3")
        }

        // Add stack generators into adapter
        adapter += verticalGenerators

        // Tell adapter that we've changed generators
        adapter => .reload
    }

}
