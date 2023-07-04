//
//  TitleCollectionFooterView.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Dmitry Korolev on 05.04.2021.
//

import UIKit
import ReactiveDataDisplayManager

class TitleIconCollectionFooterView: UICollectionReusableView, AccessibilityItem {

    // MARK: - IBOutlets

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!

    // MARK: - AccessibilityItem

    var labelStrategy: AccessibilityStringStrategy { .merge("some image with title: ", titleLabel.text) }
    var traitsStrategy: AccessibilityTraitsStrategy { .merge(iconImageView, titleLabel) }

    // MARK: - Internal methods

    func fill(title: String) {
        self.titleLabel.text = title
        self.iconImageView.image = #imageLiteral(resourceName: "ReactiveIconHorizontal")
    }

}
