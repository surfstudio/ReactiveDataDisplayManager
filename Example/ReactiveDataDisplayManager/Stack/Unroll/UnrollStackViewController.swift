//
//  UnrollStackViewController.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Dmitry Korolev on 01.04.2021.
//

import UIKit

final class UnrollStackViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var stackView: UIStackView!

    // MARK: - Private Properties

    private lazy var adapter = stackView.rddm.baseBuilder
        .build()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        fillAdapter()
    }

}

// MARK: - Private Methods

private extension UnrollStackViewController {

    /// This method is used to fill adapter
    func fillAdapter() {
        let sampleText = "LongText".localized
        // Create generators
        let generator = UnrollStackCellGenerator(with: sampleText)

        // Add generators to adapter
        adapter.addCellGenerator(generator)

        // Tell adapter that we've changed generators
        adapter.forceRefill()
    }

}
