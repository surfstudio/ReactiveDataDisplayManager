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
        .add(plugin: .foldable())
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
        adapter += makeGravityCellGenerator(with: 3)
        adapter.forceRefill()

        // Add generators with heaviness = 5 after delay equal 1 second
        delay(.now() + .seconds(1)) { [weak self] in
            guard let self = self else { return }
            self.adapter += self.makeGravityCellGenerator(with: 5)
            self.adapter.forceRefill()
        }

        // Add generators with heaviness = 2 and 1 after delay equal 3 second
        delay(.now() + .seconds(3)) { [weak self] in
            guard let self = self else { return }
            self.adapter += self.makeGravityCellGenerator(with: 2)
            self.adapter += self.makeGravityCellGenerator(with: 1)
            self.adapter.forceRefill()
        }

        // Add generators with heaviness = 4 (with children's generators have heaviness equal 1 and 2) after delay equal 2 second
        delay(.now() + .seconds(2)) { [weak self] in
            guard let self = self else { return }
            self.adapter += self.makeGravityFoldableCellGenerator(with: 4)
            self.adapter.forceRefill()
        }

    }

    func makeGravityCellGenerator(with heaviness: Int) -> GravityCellGenerator {
        let title = String(format: "Regular cell with heaviness: %d", heaviness)
        return GravityCellGenerator(model: title, heaviness: heaviness)
    }

    func makeGravityFoldableCellGenerator(with heaviness: Int) -> GravityFoldableCellGenerator {
        let generator = GravityFoldableCellGenerator(heaviness: heaviness)
        generator.childGenerators = [
            makeGravityCellGenerator(with: 1),
            makeGravityCellGenerator(with: 2)
        ]
        return generator
    }

}
