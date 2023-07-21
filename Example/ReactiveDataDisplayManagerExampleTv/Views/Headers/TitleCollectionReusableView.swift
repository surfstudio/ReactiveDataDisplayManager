//
//  TitleCollectionReusableView.swift
//  ReactiveDataDisplayManagerExample_tvOS
//
//  Created by Никита Коробейников on 09.06.2021.
//

import UIKit
import ReactiveDataDisplayManager

final class TitleCollectionReusableView: UICollectionReusableView, AccessibilityItem, CalculatableHeightItem {

    // MARK: - CalculatableHeightItem

    static func getHeight(forWidth width: CGFloat, with model: String) -> CGFloat {
        let verticalInsets: CGFloat = 48
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
