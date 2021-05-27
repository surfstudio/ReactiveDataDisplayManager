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

    /// This method is used to fill adapter
    func fillAdapter() {
        let sampleText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

        // Create generators
        let title = TextStackCellGenerator(model: .init(title: "Title text",
                                                       alignment: .left,
                                                       font: .systemFont(ofSize: 43, weight: .bold)))
        let description = TextStackCellGenerator(model: .init(title: sampleText,
                                                              alignment: .left,
                                                              font: .systemFont(ofSize: 30)))

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

// MARK: - Configuration

private extension LandingStackViewController {

    /// Appearance SrackView
    func setupInitialState() {
        stackView.layoutMargins = Constants.margins

        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.spacing = Constants.padding
    }

}
