//
//  HeaderCollectionListView.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Vadim Tikhonov on 09.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager

final class HeaderCollectionListView: UICollectionReusableView, AccessibilityItem, CalculatableHeightItem {

    // MARK: - CalculatableHeightItem

    static func getHeight(forWidth width: CGFloat, with model: String) -> CGFloat {
        let verticalInsets: CGFloat = 0
        let titleHeight = model.getHeight(withConstrainedWidth: width,
                                          font: .preferredFont(forTextStyle: .headline))
        return verticalInsets + titleHeight
    }

    // MARK: - IBOutlets

    @IBOutlet private weak var titleLabel: UILabel!

    // MARK: - AccessibilityItem

    var labelStrategy: AccessibilityStringStrategy { .from(titleLabel) }
    var traitsStrategy: AccessibilityTraitsStrategy { .from(titleLabel) }

    // MARK: - Internal Methods

    func configure(with model: String) {
        titleLabel.text = model
    }

}
