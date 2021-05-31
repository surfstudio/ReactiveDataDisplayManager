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
        let headerGenerator = TitleHeaderGenerator(model: "Section 1")
        let generators = Constants.models.map { DifferenceTableGenerator(with: $0) }
        adapter.addSection(TableHeaderGenerator: headerGenerator, cells: generators)
        adapter.reload(with: nil, animation: .bottom)

        delay(.now() + .seconds(3)) { [weak self] in
            let differentiableSections = self?.adapter.makeDifferentiableSections()
            let generators = Constants.models.map { DifferenceTableGenerator(with: $0) }
            self?.adapter.addCellGenerators(generators)
            self?.adapter.reload(with: differentiableSections, insertRowsAnimation: .left)
        }

        delay(.now() + .seconds(2)) { [weak self] in
            let differentiableSections = self?.adapter.makeDifferentiableSections()
            let headerGenerator = TitleHeaderGenerator(model: "Section 2")
            let generators = Constants.models.map { DifferenceTableGenerator(with: $0) }
            self?.adapter.addSection(TableHeaderGenerator: headerGenerator, cells: generators)
            self?.adapter.reload(with: differentiableSections, insertSectionsAnimation: .right)
        }
        
        delay(.now() + .seconds(4)) { [weak self] in
            let differentiableSections = self?.adapter.makeDifferentiableSections()
            let generator = DifferenceTableGenerator(with: "Last cell")
            self?.adapter.addCellGenerator(generator)
            self?.adapter.reload(with: differentiableSections, insertRowsAnimation: .top)
        }
    }

}
