//
//  GravityTableViewController.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 02.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager

final class GravityTableViewController: UIViewController {

    // MARK: - IBOutlet

    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Private Properties

    private lazy var adapter = tableView.rddm.gravityBuilder
        .add(plugin: TableFoldablePlugin<GravityFoldableCellGenerator>())
        .build()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Gravity table with foldable cell"
        fillAdapter()
    }

}

// MARK: - Private Methods

private extension GravityTableViewController {

    /// This method is used to fill adapter
    func fillAdapter() {
        
        // Make cell generators
        let generators: [[TableCellGenerator]] = [
            makeGravityFoldableCellGenerator(),
            makeGravityCellGenerators(),
            makeGravityFoldableCellGenerator()
        ]

        // Add generators into adapter
        generators.forEach { adapter.addCellGenerators($0) }

        // Tell adapter that we've changed generators
        adapter.forceRefill()
    }

    func makeGravityFoldableCellGenerator() -> [GravityFoldableCellGenerator] {
        let generator = GravityFoldableCellGenerator(heaviness: Int.random(in: 1...20))
        generator.childGenerators = makeGravityCellGenerators()
        return [generator]
    }

    func makeGravityCellGenerators() -> [GravityCellGenerator] {
        var generators = [GravityCellGenerator]()

        for _ in 0...2 {
            let heaviness = Int.random(in: 0...20)
            let title = String(format: "Regular cell with heaviness: %d", heaviness)
            generators.append(.init(model: title, heaviness: heaviness))
        }

        return generators
    }

}
