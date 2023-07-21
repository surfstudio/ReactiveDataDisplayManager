//
//  SizableCollectionViewCell.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Vadim Tikhonov on 11.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager

final class SizableCollectionViewCell: UICollectionViewCell {

    // MARK: - IBOutlet

    @IBOutlet private weak var titleLabel: UILabel!

    // MARK: - UICollectionViewCell

    override func awakeFromNib() {
        super.awakeFromNib()
        setupInitialState()
    }

}

// MARK: - ConfigurableItem

extension SizableCollectionViewCell: ConfigurableItem {

    func configure(with viewModel: String) {
        titleLabel.text = viewModel
    }

}

// MARK: - CalculatableHeightItem

extension SizableCollectionViewCell: CalculatableHeightItem {

    static func getHeight(forWidth width: CGFloat, with model: String) -> CGFloat {
        model.getHeight(withConstrainedWidth: width,
                        font: .preferredFont(forTextStyle: .subheadline))
    }

}

// MARK: - AccessibilityItem

extension SizableCollectionViewCell: AccessibilityItem {

    var labelStrategy: AccessibilityStringStrategy { .from(titleLabel) }
    var traitsStrategy: AccessibilityTraitsStrategy { .from(titleLabel) }

}

// MARK: - Configuration

private extension SizableCollectionViewCell {

    func setupInitialState() {
        // configure titleLabel
        titleLabel.numberOfLines = 0
        titleLabel.font = .preferredFont(forTextStyle: .subheadline)
    }

}

// MARK: - Helper

extension String {

    func getHeight(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)

        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [.font: font],
                                            context: nil)

        return ceil(boundingBox.height)
    }

}
