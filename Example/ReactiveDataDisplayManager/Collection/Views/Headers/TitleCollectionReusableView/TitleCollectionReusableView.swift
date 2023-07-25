//
//  TitleCollectionReusableView.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Dryakhlykh on 25.11.2019.
//  Copyright © 2019 Alexander Kravchenkov. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager

final class TitleCollectionReusableView: UICollectionReusableView, AccessibilityItem, CalculatableHeightItem {

    // MARK: - CalculatableHeightItem

    static func getHeight(forWidth width: CGFloat, with model: String) -> CGFloat {
        let verticalInsets: CGFloat = 20
        let titleHeight = model.getHeight(withConstrainedWidth: width,
                                          font: .preferredFont(forTextStyle: .headline))
        return verticalInsets + titleHeight
    }

    // MARK: - IBOutlets

    @IBOutlet private weak var titleLabel: UILabel!

    // MARK: - AccessibilityItem

    var labelStrategy: AccessibilityStringStrategy { .from(titleLabel) }
    var traitsStrategy: AccessibilityTraitsStrategy { .from(titleLabel) }

    // MARK: - Internal methods

    func configure(with model: String) {
        titleLabel.text = model
    }

}
