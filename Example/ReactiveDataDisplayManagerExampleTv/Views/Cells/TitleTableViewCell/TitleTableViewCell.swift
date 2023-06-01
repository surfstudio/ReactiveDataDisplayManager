// 
//  TitleTableViewCell.swift
//  ReactiveDataDisplayManagerExample_tvOS
//
//  Created by Olesya Tranina on 26.07.2021.
//  
//

import ReactiveDataDisplayManager
import UIKit

final class TitleTableViewCell: UITableViewCell {

    // MARK: - IBOutlets

    @IBOutlet private weak var titleLabel: UILabel!

    // MARK: - UITableViewCells

    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.numberOfLines = 0
        contentView.layer.cornerRadius = 10
    }

}

// MARK: - AccessibilityItem

extension TitleTableViewCell: AccessibilityItem {

    var labelStrategy: AccessibilityStringStrategy { .from(object: titleLabel) }
    var traitsStrategy: AccessibilityTraitsStrategy { .from(object: titleLabel) }

}

// MARK: - ConfigurableItem

extension TitleTableViewCell: ConfigurableItem {

    func configure(with model: TitleTableViewCellModel) {
        titleLabel.text = model.title
        contentView.backgroundColor = model.canBeFocused ? .white : .lightGray
    }

}
