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
    var valueStrategy: AccessibilityStringStrategy = .just(nil)
    lazy var traitsStrategy: AccessibilityTraitsStrategy = .from(object: titleLabel)

    var shouldOverrideStateTraits: Bool { true }

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
        updateState(state: "Normal", isSelected: false)
    }

    func applyHighlightedStyle() {
        contentView.backgroundColor = .red.withAlphaComponent(0.3)
        updateState(state: "Highlighted", isSelected: false)
    }

    func applySelectedStyle() {
        contentView.layer.borderColor = UIColor.blue.cgColor
        contentView.layer.borderWidth = 1
        updateState(state: "Selected", isSelected: true)
    }

    func applyDeselectedStyle() {
        contentView.layer.borderWidth = .zero
        updateState(state: "Normal", isSelected: false)
    }

}

// MARK: - Private

private extension HighlightableTableCell {
    func configureAppearance() {
        selectionStyle = .none
        contentView.backgroundColor = .white
    }

    func updateState(state: String, isSelected: Bool) {
        valueStrategy = .just(state)
        isSelected ? traitsStrategy.insert(.selected) : traitsStrategy.remove(.selected)
        accessibilityInvalidator?.invalidateParameters()
    }
}
