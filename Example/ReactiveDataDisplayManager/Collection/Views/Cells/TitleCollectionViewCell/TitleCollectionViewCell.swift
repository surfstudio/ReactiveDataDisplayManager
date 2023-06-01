//
//  TitleCollectionViewCell.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Ivan Smetanin on 27/01/2018.
//  Copyright © 2018 Alexander Kravchenkov. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager

final class TitleCollectionViewCell: UICollectionViewCell, AccessibilityInvalidatable {

    // MARK: - IBOutlets

    @IBOutlet private weak var titleLabel: UILabel!

    // MARK: - AccessibilityInvalidatable

    var labelStrategy: AccessibilityStringStrategy { .from(object: titleLabel) }
    var valueStrategy: AccessibilityStringStrategy = .just(nil) {
        didSet {
            accessibilityInvalidator?.invalidateParameters()
        }
    }
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
        valueStrategy = .just("Normal")
    }

    func applyHighlightedStyle() {
        contentView.backgroundColor = .white.withAlphaComponent(0.5)
        valueStrategy = .just("Highlighted")
    }

    func applySelectedStyle() {
        contentView.layer.borderColor = UIColor.blue.cgColor
        contentView.layer.borderWidth = 1
        valueStrategy = .just("Selected")
    }

    func applyDeselectedStyle() {
        contentView.layer.borderWidth = .zero
        valueStrategy = .just("Normal")
    }

}

// MARK: - Private

private extension TitleCollectionViewCell {
    func configureAppearance() {
        contentView.backgroundColor = .gray
        contentView.layer.cornerRadius = 20
        contentView.clipsToBounds = true
    }

    func updateState(state: String, isSelected: Bool) {
        valueStrategy = .just(state)
        isSelected ? traitsStrategy.insert(.selected) : traitsStrategy.remove(.selected)
        accessibilityInvalidator?.invalidateParameters()
    }
}
