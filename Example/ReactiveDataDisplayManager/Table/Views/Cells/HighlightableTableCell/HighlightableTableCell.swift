//
//  HighlightableTableCell.swift
//  ReactiveDataDisplayManagerExample_iOS
//
//  Created by porohov on 14.06.2022.
//

import ReactiveDataDisplayManager
import UIKit

final class HighlightableTableCell: UITableViewCell {

    // MARK: - IBOutlets

    @IBOutlet private weak var titleLabel: UILabel!

    // MARK: - AccessibilityInvalidatable

    var labelStrategy: AccessibilityStringStrategy { .from(object: titleLabel) }
    var valueStrategy: AccessibilityStringStrategy = .ignored
    var traitsStrategy: AccessibilityTraitsStrategy { .from(object: titleLabel) }

    // MARK: - AccessibilityInvalidatable

    override func awakeFromNib() {
        super.awakeFromNib()
        configureAppearance()
    }

}

// MARK: - ConfigurableItem

extension HighlightableTableCell: ConfigurableItem {

    func configure(with model: String) {
        titleLabel.text = model
    }

}

// MARK: - HighlightableItem

extension HighlightableTableCell: HighlightableItem {

    func applyUnhighlightedStyle() {
        contentView.backgroundColor = .white
        accessibilityValue = "Normal"
    }

    func applyHighlightedStyle() {
        contentView.backgroundColor = .red.withAlphaComponent(0.3)
        accessibilityValue = "Highlighted"
    }

    func applySelectedStyle() {
        contentView.layer.borderColor = UIColor.blue.cgColor
        contentView.layer.borderWidth = 1
        accessibilityValue = "Selected"
    }

    func applyDeselectedStyle() {
        contentView.layer.borderWidth = .zero
        accessibilityValue = "Normal"
    }

}

// MARK: - Private

private extension HighlightableTableCell {

    func configureAppearance() {
        selectionStyle = .none
        contentView.backgroundColor = .white
    }

}
