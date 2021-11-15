//
//  DifferentSizeCollectionViewCell.swift
//  ReactiveDataDisplayManagerExample_iOS
//
//  Created by porohov on 15.11.2021.
//

import UIKit
import ReactiveDataDisplayManager
import Nuke

class DifferentSizeCollectionViewCell: UICollectionViewCell {


    // MARK: - Constants

    private enum Constants {
        static let titleFont = UIFont.systemFont(ofSize: 15.0)
    }

    private var height: CGFloat?

    // MARK: - IBOutlet

    @IBOutlet private weak var titleLabel: UILabel!

    // MARK: - UICollectionViewCell

    override func awakeFromNib() {
        super.awakeFromNib()
        configureAppearance()
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let autoLayoutAttributes = super.preferredLayoutAttributesFitting(layoutAttributes)

        let targetSize = CGSize(width: layoutAttributes.frame.width, height: height ?? 0)
        let autoLayoutFrame = CGRect(origin: autoLayoutAttributes.frame.origin, size: targetSize)

        // Assign the new size to the layout attributes
        autoLayoutAttributes.frame = autoLayoutFrame
        return autoLayoutAttributes
    }

}

// MARK: - Configurable

extension DifferentSizeCollectionViewCell: ConfigurableItem {

    func configure(with viewModel: DifferentSizeCollectionViewCellModel) {
        titleLabel.text = viewModel.title
        backgroundColor = viewModel.backgroundColor
        height = viewModel.height
    }

}

// MARK: - Configuration

private extension DifferentSizeCollectionViewCell {

    func configureAppearance() {
        // configure titleLabel
        titleLabel.numberOfLines = 0
        titleLabel.font = Constants.titleFont
        layer.cornerRadius = 10
    }

}
