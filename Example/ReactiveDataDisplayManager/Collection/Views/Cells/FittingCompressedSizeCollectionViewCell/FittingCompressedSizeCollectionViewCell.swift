//
//  DifferentSizeCollectionViewCell.swift
//  ReactiveDataDisplayManagerExample_iOS
//
//  Created by porohov on 15.11.2021.
//

import UIKit
import ReactiveDataDisplayManager
import Nuke

class FittingCompressedSizeCollectionViewCell: UICollectionViewCell {

    // MARK: - IBOutlets

    @IBOutlet private weak var titleLabel: UILabel!

    // MARK: - UICollectionViewCell

    override func awakeFromNib() {
        super.awakeFromNib()
        configureAppearance()
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        layoutIfNeeded()

        let layoutAttributes = layoutAttributes
        var fittingSize = UIView.layoutFittingCompressedSize
        fittingSize.width = layoutAttributes.size.width
        let size = systemLayoutSizeFitting(
            fittingSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .defaultLow
        )
        layoutAttributes.frame.size = size
        return layoutAttributes
    }

}

// MARK: - ConfigurableItem

extension FittingCompressedSizeCollectionViewCell: ConfigurableItem {

    func configure(with viewModel: DifferentSizeCollectionViewCellModel) {
        titleLabel.text = viewModel.title
        backgroundColor = viewModel.backgroundColor.withAlphaComponent(0.5)
    }

}

extension FittingCompressedSizeCollectionViewCell: AccessibilityItem {

    var labelStrategy: AccessibilityStringStrategy { .from(object: titleLabel) }
    var traitsStrategy: AccessibilityTraitsStrategy { .from(object: titleLabel) }

}

// MARK: - Configuration

private extension FittingCompressedSizeCollectionViewCell {

    func configureAppearance() {
        titleLabel.numberOfLines = 0
        layer.cornerRadius = 10
    }

}
