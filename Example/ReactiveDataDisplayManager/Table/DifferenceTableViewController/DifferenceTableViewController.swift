//
//  DifferenceTableViewController.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 12.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//
#if os(iOS)
import UIKit
import ReactiveDataDisplayManager

final class DifferenceTableViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let models = [String](repeating: "Cell", count: 3)
    }

    // MARK: - IBOutlet

    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Private Properties

    private lazy var adapter = tableView.rddm.manualBuilder
        .build()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "table with DifferenceKit"
        fillAdapter()
    }

}

// MARK: - Private Methods

private extension DifferenceTableViewController {

    func fillAdapter() {
        adapter.reload(animation: .bottom) { adapter in
            let headerGenerator = TitleHeaderGenerator(model: "Section 1")
            let generators = Constants.models.map { DiffableCellGenerator(with: $0) }
            adapter.addSection(TableHeaderGenerator: headerGenerator, cells: generators)
        }

        delay(.now() + .seconds(3)) { [weak self] in
            self?.adapter.reload(insertRowsAnimation: .left) { adapter in
                let generators = Constants.models.map { DiffableCellGenerator(with: $0) }
                adapter.addCellGenerators(generators)
            }
        }

        delay(.now() + .seconds(2)) { [weak self] in
            self?.adapter.reload(insertSectionsAnimation: .right) { adapter in
                let headerGenerator = TitleHeaderGenerator(model: "Section 2")
                let generators = Constants.models.map { DiffableCellGenerator(with: $0) }
                adapter.addSection(TableHeaderGenerator: headerGenerator, cells: generators)
            }
        }

        delay(.now() + .seconds(4)) { [weak self] in
            self?.adapter.reload(insertRowsAnimation: .top) { adapter in
                let generator = DiffableCellGenerator(with: "Last cell")
                adapter.addCellGenerator(generator)
            }
        }
    }

}
#endif
