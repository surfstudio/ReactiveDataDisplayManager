//
//  UnrollCellStackView.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Dmitry Korolev on 02.04.2021.
//

import UIKit
import ReactiveDataDisplayManager

final class UnrollCellStackView: UIView {

    // MARK: - Private Properties

    private let unrollButton = UIButton()
    private let bigTextLabel = UILabel()
    private var isUnroll = false

    // MARK: - Initialisation

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialState()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupInitialState()
    }

}

// MARK: - ConfigurableItem

extension UnrollCellStackView: ConfigurableItem {

    func configure(with model: String) {
        bigTextLabel.text = model
        updateBigTextLabel()
        updateUnrollButton()
    }

}

// MARK: - Configuration

private extension UnrollCellStackView {

    func setupInitialState() {
        let mainStack = UIStackView()
        mainStack.axis = .vertical
        mainStack.distribution = .fill
        unrollButton.setTitleColor(.blue, for: .normal)
        unrollButton.addTarget(self, action: #selector(unrollAction), for: .touchUpInside)
        mainStack.addArrangedSubview(bigTextLabel)
        mainStack.addArrangedSubview(unrollButton)

        mainStack.translatesAutoresizingMaskIntoConstraints = false
        let top = mainStack.topAnchor.constraint(equalTo: topAnchor)
        let bottom = mainStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        let leading = mainStack.leadingAnchor.constraint(equalTo: leadingAnchor)
        let trailing = mainStack.trailingAnchor.constraint(equalTo: trailingAnchor)

        addSubview(mainStack)
        addConstraints([top, bottom, leading, trailing])
    }

    func updateBigTextLabel() {
        bigTextLabel.numberOfLines = isUnroll ? 0 : 3
    }

    func updateUnrollButton() {
        let title = isUnroll ? "Less" : "More"
        unrollButton.setTitle(title, for: .normal)
    }

}

// MARK: - Actions

private extension UnrollCellStackView {

    @objc
    func unrollAction() {
        isUnroll.toggle()
        updateBigTextLabel()
        updateUnrollButton()
    }

}
