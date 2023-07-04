//
//  TitleTableViewCell.swift
//  ReactiveDataDisplayManager
//
//  Created by Ivan Smetanin on 19/12/2017.
//  Copyright © 2017 Alexander Kravchenkov. All rights reserved.
//

import ReactiveDataDisplayManager
import UIKit

class TitleTableViewCell: UITableViewCell, CalculatableHeightItem {

    // MARK: - IBOutlets

    @IBOutlet private weak var titleLabel: UILabel!

    // MARK: - CalculatableHeightItem

    static func getHeight(forWidth width: CGFloat, with model: String) -> CGFloat {
        return 44
    }

}

// MARK: - AccessibilityItem

extension TitleTableViewCell: AccessibilityItem {

    var labelStrategy: AccessibilityStringStrategy { .from(titleLabel) }
    var traitsStrategy: AccessibilityTraitsStrategy { .from(titleLabel) }

}

// MARK: - ConfigurableItem

extension TitleTableViewCell: ConfigurableItem {

    func configure(with model: String) {
        titleLabel.text = model
        accessibilityLabel = model
        backgroundColor = .clear
    }

}
