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
        .add(plugin: .accessibility())
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

        // Add section into adapter
        adapter += Section(header: EmptyTableHeaderGenerator(), footer: EmptyTableFooterGenerator()) {
            TableVStack {
                TitleTableViewCell.buildView(with: "Текст 1")
                TitleTableViewCell.buildView(with: "Текст 2")
                TableHStack {
                    TitleTableViewCell.buildView(with: "Текст 4")
                    TitleTableViewCell.buildView(with: "Текст 5")
                }
                TitleTableViewCell.buildView(with: "Текст 3")
            }
            .didSelectEvent {
                print("VerticalTableStack did select event")
            }
        }

        // Tell adapter that we've changed generators
        adapter => .reload
    }

}
