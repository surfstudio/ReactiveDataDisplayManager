//
//  StackViewController.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Dryakhlykh on 14.10.2019.
//  Copyright © 2019 Alexander Kravchenkov. All rights reserved.
//

import ReactiveDataDisplayManager

final class StackViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var stackView: UIStackView!
    
    // MARK: - Properties

    private lazy var adapter = BaseStackDataDisplayManager(collection: stackView)
    private lazy var titles: [String] = ["One", "Two", "Three", "Four"]

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        fillAdapter()
    }

    // MARK: - Private methods

    /// This method is used to fill adapter
    private func fillAdapter() {
        for title in titles {
            // Create generator
            let generator = TitleStackCellGenerator(title: title)
            // Add generator to adapter
            adapter.addCellGenerator(generator)
        }

        // Tell adapter that we've changed generators
        adapter.forceRefill()
    }

}
