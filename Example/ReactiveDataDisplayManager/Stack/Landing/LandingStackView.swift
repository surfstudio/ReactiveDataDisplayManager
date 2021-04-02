//
//  LandingStackView.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Dmitry Korolev on 02.04.2021.
//

import UIKit

final class LandingStackView: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let padding: CGFloat = 15
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

private extension LandingStackView {

    /// This method is used to fill adapter
    func fillAdapter() {
        let sampleText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

        // Create generators
        let tite = TextStackCellGenerator.init(title: "Title text", fontSize: 43, weight: .bold)
        let description = TextStackCellGenerator.init(title: sampleText, fontSize: 30)
        let buttons = ButtonsCellGenerator(buttonOneTapped: buttonOneTapper, buttonTwoTapped: buttonTwoTapper)

        // Add generators to adapter
        adapter.addCellGenerator(tite)
        adapter.addCellGenerator(description)
        adapter.addCellGenerator(buttons)

        // Tell adapter that we've changed generators
        adapter.forceRefill()
    }

    /// Buttons Actions
    func buttonOneTapper() {
        print("button one tapped")
    }

    func buttonTwoTapper() {
        print("button two tapped")
    }

}

// MARK: - Configuration

private extension LandingStackView {

    /// Appearance SrackView
    func setupInitialState() {
        stackView.layoutMargins = UIEdgeInsets(top: Constants.padding,
                                               left: Constants.padding,
                                               bottom: Constants.padding,
                                               right: Constants.padding)

        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.spacing = Constants.padding
    }

}
