//
//  TitleCollectionViewCell.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Ivan Smetanin on 27/01/2018.
//  Copyright © 2018 Alexander Kravchenkov. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager

final class TitleCollectionViewCell: UICollectionViewCell {

    // MARK: - IBOutlets

    @IBOutlet private weak var titleLabel: UILabel!

    // MARK: - AccessibilityInvalidatable

    var labelStrategy: AccessibilityStringStrategy { .from(object: titleLabel) }
    var valueStrategy: AccessibilityStringStrategy = .ignored
    var traitsStrategy: AccessibilityTraitsStrategy { .from(object: titleLabel) }

    var accessibilityInvalidator: AccessibilityItemInvalidator?

    // MARK: - UICollectionViewCell

    override func awakeFromNib() {
        super.awakeFromNib()
        configureAppearance()
    }

}

// MARK: - ConfigurableItem

extension TitleCollectionViewCell: ConfigurableItem {

    func configure(with title: String) {
        titleLabel.text = title
    }

}

// MARK: - HighlightableItem

extension TitleCollectionViewCell: HighlightableItem {

    func applyUnhighlightedStyle() {
        contentView.backgroundColor = .gray
        accessibilityValue = "Normal"
    }

    func applyHighlightedStyle() {
        contentView.backgroundColor = .white.withAlphaComponent(0.5)
        accessibilityValue = "Highlighted"
    }

    func applySelectedStyle() {
        contentView.layer.borderColor = UIColor.blue.cgColor
        contentView.layer.borderWidth = 1
        accessibilityValue = "Selected"
    }

    func applyDeselectedStyle() {
        contentView.layer.borderWidth = .zero
        accessibilityValue = "Normal"
    }

}

// MARK: - Private

private extension TitleCollectionViewCell {

    func configureAppearance() {
        contentView.backgroundColor = .gray
        contentView.layer.cornerRadius = 20
        contentView.clipsToBounds = true
    }

}
