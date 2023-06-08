//
//  TitleWithIconTableViewCell.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Dmitry Korolev on 30.03.2021.
//

import UIKit
import ReactiveDataDisplayManager

class TitleWithIconTableViewCell: UITableViewCell, CalculatableHeightItem {

    // MARK: - IBOutlets

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!

    // MARK: - CalculatableHeightItem

    static func getHeight(forWidth width: CGFloat, with model: String) -> CGFloat {
        return model.getHeight(withConstrainedWidth: UIScreen.main.bounds.width,
                               font: .preferredFont(forTextStyle: .body))
    }

}

// MARK: - AccessibilityItem

extension TitleWithIconTableViewCell: AccessibilityItem {

    var labelStrategy: AccessibilityStringStrategy { .from(object: titleLabel) }
    var traitsStrategy: AccessibilityTraitsStrategy { .merge([iconImageView, titleLabel]) }

}

// MARK: - ConfigurableItem

extension TitleWithIconTableViewCell: ConfigurableItem {

    func configure(with model: String) {
        accessoryType = .disclosureIndicator
        titleLabel.text = model
        iconImageView.image = #imageLiteral(resourceName: "ReactiveIconHorizontal")
    }

}
