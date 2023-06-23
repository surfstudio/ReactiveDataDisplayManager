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

    override func awakeFromNib() {
        super.awakeFromNib()
        configureAppearance()
    }

}

// MARK: - ConfigurableItem

extension TitleCollectionViewCell: ConfigurableItem {

    func configure(with title: String) {
        titleLabel.text = title
        accessibilityLabel = title
    }

}

// MARK: - HighlightableItem

extension TitleCollectionViewCell: HighlightableItem {

    func applyUnhighlightedStyle() {
        contentView.backgroundColor = .gray
        accessibilityLabel = "Normal"
    }

    func applyHighlightedStyle() {
        contentView.backgroundColor = .white.withAlphaComponent(0.5)
        accessibilityLabel = "Highlighted"
    }

    func applySelectedStyle() {
        contentView.layer.borderColor = UIColor.blue.cgColor
        contentView.layer.borderWidth = 1
        accessibilityLabel = "Selected"
    }

    func applyDeselectedStyle() {
        contentView.layer.borderWidth = .zero
        accessibilityLabel = "Normal"
    }

}

// MARK: - CalculatableHeightItem

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

}
