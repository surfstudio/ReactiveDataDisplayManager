//
//  StackViewController.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Dryakhlykh on 14.10.2019.
//  Copyright © 2019 Alexander Kravchenkov. All rights reserved.
//

import ReactiveDataDisplayManager
import UIKit

final class StackViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var stackView: UIStackView!
    
    // MARK: - Private Properties

    private lazy var adapter = stackView.rddm.baseBuilder.build()
    private let titles = ["One", "Two", "Three", "Four"]

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        fillAdapter()
    }

}

// MARK: - Private Methods

private extension StackViewController {

    /// This method is used to fill adapter
    func fillAdapter() {
        // Create generators
        let generators = titles.map(TitleStackCellGenerator.init)

        // Add generators to adapter
        adapter.addCellGenerators(generators)

        // Tell adapter that we've changed generators
        adapter.forceRefill()
    }

}
