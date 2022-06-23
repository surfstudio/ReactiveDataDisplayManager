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

    override func awakeFromNib() {
        super.awakeFromNib()
        configureAppearance()
    }

    // MARK: - Internal methods

    func fill(with title: String) {
        titleLabel.text = title
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
        accessibilityLabel = "Normal"
    }

    func applyHighlightedStyle() {
        contentView.backgroundColor = .red.withAlphaComponent(0.3)
        accessibilityLabel = "Highlighted"
    }

    func applySelectedStyle() {
        contentView.layer.borderColor = UIColor.blue.cgColor
        contentView.layer.borderWidth = 1
        accessibilityLabel = "Selected"
    }

    func applyDeselectedStyle() {
        contentView.layer.borderWidth = .zero
        accessibilityLabel = "Normal"
    }

}

// MARK: - Private

private extension HighlightableTableCell {

    func configureAppearance() {
        selectionStyle = .none
        contentView.backgroundColor = .white
    }

}
