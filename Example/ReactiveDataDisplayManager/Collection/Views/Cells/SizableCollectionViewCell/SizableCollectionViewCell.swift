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

    // MARK: - Constants

    private enum Constants {
        static let titleFont = UIFont.preferredFont(forTextStyle: .subheadline)
    }

    // MARK: - IBOutlet

    @IBOutlet private weak var titleLabel: UILabel!

    // MARK: - UICollectionViewCell

    override func awakeFromNib() {
        super.awakeFromNib()
        setupInitialState()
    }

    // MARK: - Static Methods

    static func getCellSize(for viewModel: String, withWight wight: CGFloat) -> CGSize {
        let height = viewModel.getHeight(withConstrainedWidth: wight, font: Constants.titleFont)
        return CGSize(width: wight, height: height)
    }

}

// MARK: - ConfigurableItem

extension SizableCollectionViewCell: ConfigurableItem {

    func configure(with viewModel: String) {
        titleLabel.text = viewModel
    }

}

// MARK: - AccessibilityItem

extension SizableCollectionViewCell: AccessibilityItem {

    var labelStrategy: AccessibilityStringStrategy { .from(object: titleLabel) }
    var traitsStrategy: AccessibilityTraitsStrategy { .from(object: titleLabel) }

}

// MARK: - Configuration

private extension SizableCollectionViewCell {

    func setupInitialState() {
        // configure titleLabel
        titleLabel.numberOfLines = 0
        titleLabel.font = Constants.titleFont
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
