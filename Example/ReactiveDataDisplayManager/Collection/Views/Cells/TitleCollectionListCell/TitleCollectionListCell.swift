//
//  TitleCollectionListCell.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Vadim Tikhonov on 09.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager

class TitleCollectionListCell: UICollectionViewCell, ConfigurableItem, AccessibilityItem {

    // MARK: - IBOutlets

    @IBOutlet private weak var titleLabel: UILabel!

    // MARK: - AccessibilityItem

    var labelStrategy: AccessibilityStringStrategy { .from(object: titleLabel) }
    var traitsStrategy: AccessibilityTraitsStrategy { .from(object: titleLabel) }

    // MARK: - Configurable

    func configure(with title: String) {
        titleLabel.text = title
        backgroundColor = .lightGray
    }

}

// MARK: - CalculatableHeightItem

extension TitleCollectionListCell: CalculatableHeightItem {

    static func getHeight(forWidth width: CGFloat, with model: String) -> CGFloat {
        let horizontalInsets: CGFloat = 32
        let verticalInsets: CGFloat = 42
        let titleHeight = model.getHeight(withConstrainedWidth: width - horizontalInsets,
                                          font: .preferredFont(forTextStyle: .body))
        return verticalInsets + titleHeight
    }

}
