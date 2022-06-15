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

    func applyNormalStyle() {
        contentView.backgroundColor = .white
    }

    func applyHighlightedStyle() {
        contentView.backgroundColor = .red.withAlphaComponent(0.3)
    }

}

// MARK: - Private

private extension HighlightableTableCell {

    func configureAppearance() {
        selectionStyle = .none
        contentView.backgroundColor = .white
    }

}
