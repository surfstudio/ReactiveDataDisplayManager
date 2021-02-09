//
//  FoldableTableViewCell.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 01.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import UIKit

final class FoldableTableViewCell: UITableViewCell {

    // MARK: - Constants

    private enum Constants {
        static let titleLabelText = "Foldable cell"
        static let animationDuration: TimeInterval = 0.3
    }

    // MARK: - IBOutlets

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var arrowImageView: UIImageView!

    // MARK: - UITableViewCell

    override func awakeFromNib() {
        super.awakeFromNib()
        setupInitialState()
    }

    // MARK: - Public Methods

    func fill(title: String = "", expanded: Bool) {
        titleLabel.text = String(format: "Foldable cell %@", title)
        arrowImageView.transform = expanded ? .identity : CGAffineTransform(rotationAngle: .pi)
    }

    func configure(expanded: Bool) {
        UIView.animate(withDuration: Constants.animationDuration) { [weak self] in
            self?.arrowImageView.transform = expanded ? .identity : CGAffineTransform(rotationAngle: .pi)
        }
    }

}

// MARK: - Configuration

private extension FoldableTableViewCell {

    func setupInitialState() {
        selectionStyle = .none
        arrowImageView.image = #imageLiteral(resourceName: "upArrow")
    }

}
