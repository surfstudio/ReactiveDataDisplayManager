//
//  HighlightableTableCell.swift
//  ReactiveDataDisplayManagerExample_iOS
//
//  Created by porohov on 14.06.2022.
//

import ReactiveDataDisplayManager
import UIKit

final class HighlightableTableCell: UITableViewCell, AccessibilityInvalidatable {

    // MARK: - IBOutlets

    @IBOutlet private weak var titleLabel: UILabel!

    // MARK: - AccessibilityInvalidatable

    var labelStrategy: AccessibilityStringStrategy { .from(object: titleLabel) }
    var valueStrategy: AccessibilityStringStrategy = .just(nil) {
        didSet {
            accessibilityInvalidator?.invalidateParameters()
        }
    }
    var traitsStrategy: AccessibilityTraitsStrategy { .from(object: titleLabel) }

    var accessibilityInvalidator: AccessibilityItemInvalidator?

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
        valueStrategy = .just("Normal")
    }

    func applyHighlightedStyle() {
        contentView.backgroundColor = .red.withAlphaComponent(0.3)
        valueStrategy = .just("Highlighted")
    }

    func applySelectedStyle() {
        contentView.layer.borderColor = UIColor.blue.cgColor
        contentView.layer.borderWidth = 1
        valueStrategy = .just("Selected")
    }

    func applyDeselectedStyle() {
        contentView.layer.borderWidth = .zero
        valueStrategy = .just("Normal")
    }

}

// MARK: - Private

private extension HighlightableTableCell {

    func configureAppearance() {
        selectionStyle = .none
        contentView.backgroundColor = .white
    }

}
