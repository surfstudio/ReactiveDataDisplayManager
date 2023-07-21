//
//  DifferenceTableViewController.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 12.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager

final class DifferenceTableViewController: UIViewController {

    typealias DiffableGenerator = DiffableCellGenerator<TitleTableViewCell>

    // MARK: - Constants

    private enum Constants {
        static let models = [String](repeating: "Cell", count: 3)
    }

    // MARK: - IBOutlet

    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Private Properties

    private lazy var adapter = tableView.rddm.manualBuilder
        .add(plugin: .accessibility())
        .build()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "DifferenceKit"
        fillAdapter()
    }

}

// MARK: - Private Methods

private extension DifferenceTableViewController {

    func fillAdapter() {
        adapter.reload(animation: .bottom) { adapter in
            let headerGenerator = TitleHeaderGenerator(id: 1, model: "Section 1")
            let generators = Constants.models.enumerated().map {
                TitleTableViewCell.rddm.diffableGenerator(uniqueId: $0.offset, with: $0.element)
            }
            adapter.addSection(TableHeaderGenerator: headerGenerator, cells: generators)
        }

        delay(.now() + .seconds(3)) { [weak self] in
            self?.adapter.reload(insertRowsAnimation: .left) { adapter in
                let generators = Constants.models.enumerated().map {
                    TitleTableViewCell.rddm.diffableGenerator(uniqueId: $0.offset + Constants.models.count,
                                                              with: $0.element)
                }
                adapter += generators
            }
        }

        delay(.now() + .seconds(2)) { [weak self] in
            self?.adapter.reload(insertSectionsAnimation: .right) { adapter in
                let headerGenerator = TitleHeaderGenerator(id: 2, model: "Section 2")
                let generators = Constants.models.enumerated().map {
                    TitleTableViewCell.rddm.diffableGenerator(uniqueId: $0.offset, with: $0.element)
                }
                adapter.addSection(TableHeaderGenerator: headerGenerator, cells: generators)
            }
        }

        delay(.now() + .seconds(4)) { [weak self] in
            self?.adapter.reload(insertRowsAnimation: .top) { adapter in
                let generator = TitleTableViewCell.rddm.diffableGenerator(uniqueId: "Last cell", with: "Last cell")
                adapter += generator
            }
        }
    }

}
