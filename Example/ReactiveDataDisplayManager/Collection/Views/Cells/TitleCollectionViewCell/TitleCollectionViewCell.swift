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
    }

}

// MARK: - HighlightableItem

extension TitleCollectionViewCell: HighlightableItem {

    func applyNormalStyle() {
        contentView.backgroundColor = .gray
    }

    func applyHighlightedStyle() {
        contentView.backgroundColor = .white.withAlphaComponent(0.5)
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
