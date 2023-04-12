//
//  PaginatorView.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Никита Коробейников on 03.03.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager

final class PaginatorView: UIView {

    private var retryAction: (() -> Void)?

    private lazy var indicator = UIActivityIndicatorView(style: .gray)

    private lazy var errorLabel =  {
        $0.textAlignment = .center
        return $0
    }(UILabel.base)

    private lazy var retryButton = {
        $0.setTitle("Retry", for: .normal)
        $0.addTarget(nil, action: #selector(self.onRetryTapped), for: .touchUpInside)
        return $0
    }(UIButton.base)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialState()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupInitialState()
    }

    private func setupInitialState() {
        backgroundColor = .clear
        addActvityIndicator()
        addErrorStateViews()
    }

    private func addActvityIndicator() {
        addSubview(indicator)
        indicator.accessibilityIdentifier = String(describing: Self.self)
        indicator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }

    private func addErrorStateViews() {
        addSubview(errorLabel)
        addSubview(retryButton)

        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        retryButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            errorLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            retryButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 8),
            retryButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            retryButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])

        errorLabel.isHidden = true
        retryButton.isHidden = true
    }

    @objc
    private func onRetryTapped() {
        showError(nil)
        retryAction?()
    }
}

// MARK: - ProgressDisplayableItem

extension PaginatorView: ProgressDisplayableItem {

    func setOnRetry(action: @autoclosure @escaping () -> Void) {
        retryAction = action
    }

    func showProgress(_ isLoading: Bool) {
        isLoading ? indicator.startAnimating() : indicator.stopAnimating()
    }

    func showError(_ error: Error?) {
        if let error {
            errorLabel.isHidden = false
            retryButton.isHidden = false

            // It's recommended to override localizedDescription or parse error to user-friendly text in other way
            errorLabel.text = (error as? SampleError)?.localizedDescription
        } else {
            errorLabel.isHidden = true
            retryButton.isHidden = true
        }
    }

}
