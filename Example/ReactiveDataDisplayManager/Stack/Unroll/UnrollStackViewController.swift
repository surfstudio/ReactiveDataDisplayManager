//
//  UnrollStackViewController.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Dmitry Korolev on 01.04.2021.
//

import UIKit

class UnrollStackViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var stackView: UIStackView!
    
    // MARK: - Private Properties
    private let titles = ["One", "Two", "Three", "Four"]
    private lazy var adapter = stackView.rddm.baseBuilder.build()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        fillAdapter()
    }

}

private extension UnrollStackViewController {
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
