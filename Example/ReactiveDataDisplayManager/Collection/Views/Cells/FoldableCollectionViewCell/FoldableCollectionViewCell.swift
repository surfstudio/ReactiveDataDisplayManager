//
//  FoldableCollectionViewCell.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Vadim Tikhonov on 11.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager
import Nuke

final class FoldableCollectionViewCell: UICollectionViewCell {

    // MARK: - ViewModel

    struct ViewModel {
        let color: UIColor
    }

    // MARK: - Constants

    private enum Constants {
        static let cornerRadius: CGFloat = 10
        static let animationDuration: TimeInterval = 0.3
    }

    // MARK: - IBOutlet

    @IBOutlet private weak var arrowImageView: UIImageView!

    // MARK: - UICollectionViewCell

    override func awakeFromNib() {
        super.awakeFromNib()
        setupInitialState()
    }

    // MARK: - Internal Methods

    func update(isExpanded: Bool) {
        UIView.animate(withDuration: Constants.animationDuration) { [weak self] in
            self?.arrowImageView.transform = isExpanded ? .identity : CGAffineTransform(rotationAngle: .pi)
        }
    }

}

// MARK: - Configurable

extension FoldableCollectionViewCell: ConfigurableItem {

    func configure(with viewModel: ViewModel) {
        contentView.backgroundColor = viewModel.color
    }

}

// MARK: - Configuration

private extension FoldableCollectionViewCell {

    func setupInitialState() {
        // configure contentView
        contentView.layer.cornerRadius = Constants.cornerRadius
        contentView.layer.masksToBounds = true

        // configure arrowImageView
        arrowImageView.image = #imageLiteral(resourceName: "upArrow")
    }

}
