//
//  PrefetchingTableViewController.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 29.01.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager

final class PrefetchingTableViewController: UIViewController {

    // MARK: - Private Properties

    private let tableView = UITableView()
    private let preheater = NukePreheater()

    private lazy var adapter = tableView.rddm.baseBuilder
        .add(plugin: TablePreheaterablePlugin(preheater: preheater))
        .build()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialState()
        fillAdapter()
    }

}

// MARK: - Configuration

private extension PrefetchingTableViewController {

    func setupInitialState() {
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

}

// MARK: - Private Methods

private extension PrefetchingTableViewController {

    /// This method is used to fill adapter
    func fillAdapter() {
        for _ in 0...300 {
            // Create viewModels for cell
            guard let viewModel = makeImageCellViewModel() else { continue }

            // Create generator
            let generator = ImageTableGenerator(model: viewModel)

            // Add generator to adapter
            adapter.addCellGenerator(generator)
        }

        // Tell adapter that we've changed generators
        adapter.forceRefill()
    }

    /// Method makes the cell viewModel
    func makeImageCellViewModel() -> ImageTableViewCell.ViewModel? {
        let stringImageUrl = "https://picsum.photos/id/\(Int.random(in: 50...500))/400/300"
        guard let imageUrl = URL(string: stringImageUrl) else { return nil }
        return .init(imageUrl: imageUrl, title: stringImageUrl)
    }

}

