//
//  ButtonsCellGenerator.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Dmitry Korolev on 02.04.2021.
//

import ReactiveDataDisplayManager

final class ButtonsCellGenerator: StackCellGenerator {

    // MARK: - Properties

    let buttonOneTapped: () -> Void
    let buttonTwoTapped: () -> Void

    // MARK: - Initialization

    init(buttonOneTapped: @escaping () -> Void, buttonTwoTapped: @escaping () -> Void) {
        self.buttonOneTapped = buttonOneTapped
        self.buttonTwoTapped = buttonTwoTapped
    }

}

// MARK: - ViewBuilder

extension ButtonsCellGenerator: ViewBuilder {

    func build(view: UIStackView) {

        // Stack view configure
        view.distribution = .fillEqually
        view.spacing = 10

        // Button one configure
        let buttonOne = UIButton()
        buttonOne.setTitle("Button One", for: .normal)
        buttonOne.backgroundColor = .gray
        buttonOne.setTitleColor(.white, for: .normal)
        buttonOne.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .highlighted)
        buttonOne.addTarget(self, action: #selector(buttonOneTappedAction), for: .touchUpInside)

        // Button two configure
        let buttonTwo = UIButton()
        buttonTwo.setTitle("Button Two", for: .normal)
        buttonTwo.backgroundColor = .gray
        buttonTwo.setTitleColor(.white, for: .normal)
        buttonTwo.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .highlighted)
        buttonTwo.addTarget(self, action: #selector(buttonTwoTappedAction), for: .touchUpInside)

        view.addArrangedSubview(buttonOne)
        view.addArrangedSubview(buttonTwo)
    }

}

// MARK: - Actions

extension ButtonsCellGenerator {

    @objc
    func buttonOneTappedAction() {
        buttonOneTapped()
    }

    @objc
    func buttonTwoTappedAction() {
        buttonTwoTapped()
    }

}
