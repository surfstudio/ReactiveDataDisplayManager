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

    var labelStrategy: AccessibilityStringStrategy { .from(titleLabel) }
    var valueStrategy: AccessibilityStringStrategy = .just(nil)
    lazy var traitsStrategy: AccessibilityTraitsStrategy = .from(titleLabel)
    var shouldOverrideStateTraits: Bool { true }

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
        updateState(state: "Normal", isSelected: false)
    }

    func applyHighlightedStyle() {
        contentView.backgroundColor = .white.withAlphaComponent(0.5)
        updateState(state: "Highlighted", isSelected: true)
    }

    func applySelectedStyle() {
        contentView.layer.borderColor = UIColor.blue.cgColor
        contentView.layer.borderWidth = 1
        updateState(state: "Selected", isSelected: true)
    }

    func applyDeselectedStyle() {
        contentView.layer.borderWidth = .zero
        updateState(state: "Normal", isSelected: false)
    }

}

extension TitleCollectionViewCell: CalculatableHeightItem {

    static func getHeight(forWidth width: CGFloat, with model: String) -> CGFloat {
        let horizontalInsets: CGFloat = 32
        let verticalInsets: CGFloat = 29
        let titleHeight = model.getHeight(withConstrainedWidth: width - horizontalInsets,
                                          font: .preferredFont(forTextStyle: .body))
        return verticalInsets + titleHeight
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
