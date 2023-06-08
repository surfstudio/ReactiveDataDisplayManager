//
//  LandingStackViewController.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Dmitry Korolev on 02.04.2021.
//

import UIKit

final class LandingStackViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let padding: CGFloat = 16
        static let margins = UIEdgeInsets(top: padding,
                                          left: padding,
                                          bottom: padding,
                                          right: padding)
    }

    // MARK: - IBOutlets

    @IBOutlet private weak var stackView: UIStackView!

    // MARK: - Private Properties

    private lazy var adapter = stackView.rddm.baseBuilder.build()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialState()
        fillAdapter()
    }

}

// MARK: - Private Methods

private extension LandingStackViewController {

    /// Appearance SrackView
    func setupInitialState() {
        stackView.layoutMargins = Constants.margins

        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.spacing = Constants.padding
    }

    /// This method is used to fill adapter
    func fillAdapter() {
        let sampleText = "LongText".localized

        // Create generators

        let title = TextStackCellGenerator(model: .init(title: "Title text",
                                                        alignment: .left,
                                                        font: .preferredFont(forTextStyle: .largeTitle)))
        let description = TextStackCellGenerator(model: .init(title: sampleText,
                                                              alignment: .left,
                                                              font: .preferredFont(forTextStyle: .title1)))

        let mainButton = ButtonStackCellGenerator(model: .init(title: "Main",
                                                               titleColor: .black,
                                                               backgroundColor: .rddm)) {
            print("Main button tapped")
        }

        let secondaryButton = ButtonStackCellGenerator(model: .init(title: "Secondary",
                                                               titleColor: .white,
                                                               backgroundColor: .gray)) {
            print("Secondary button tapped")
        }

        let buttons = InnerStackCellGenerator(model: .init(axis: .horizontal,
                                                           alignment: .center,
                                                           distribution: .fillEqually,
                                                           spacing: 32),
                                              childGenerators: [mainButton, secondaryButton])

        // Add generators to adapter
        adapter.addCellGenerator(title)
        adapter.addCellGenerator(description)
        adapter.addCellGenerator(buttons)

        // Tell adapter that we've changed generators
        adapter.forceRefill()
    }

}
