//
//  FoldableTableViewCell.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 01.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager

final class FoldableTableViewCell: UITableViewCell, AccessibilityInvalidatable {

    struct Model {
        let title: String
        let isExpanded: Bool
    }

    // MARK: - Constants

    private enum Constants {
        static let titleLabelText = "Foldable cell"
        static let animationDuration: TimeInterval = 0.3
    }

    // MARK: - IBOutlets

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var arrowImageView: UIImageView!

    // MARK: - Private Properties

    private var isExpanded = false {
        didSet {
            accessibilityInvalidator?.invalidateParameters()
        }
    }

    // MARK: - AccessibilityInvalidatable

    var accessibilityInvalidator: AccessibilityItemInvalidator?

    // MARK: - UITableViewCell

    override func awakeFromNib() {
        super.awakeFromNib()
        setupInitialState()
    }

    // MARK: - Internal Methods

    func update(isExpanded: Bool) {
        self.isExpanded = isExpanded
        UIView.animate(withDuration: Constants.animationDuration) { [weak self] in
            self?.arrowImageView.transform = isExpanded ? .identity : CGAffineTransform(rotationAngle: .pi)
        }
    }

}

// MARK: - AccessibilityItem

extension FoldableTableViewCell: AccessibilityItem {

    var labelStrategy: AccessibilityStringStrategy { .from(object: titleLabel) }
    var valueStrategy: AccessibilityStringStrategy { .just("isExpanded: \(isExpanded)") }
    var traitsStrategy: AccessibilityTraitsStrategy { .from(object: titleLabel) }

}

// MARK: - ConfigurableItem

extension FoldableTableViewCell: ConfigurableItem {

    func configure(with model: Model) {
        titleLabel.text = String(format: "Foldable cell %@", model.title)
        arrowImageView.transform = model.isExpanded ? .identity : CGAffineTransform(rotationAngle: .pi)
        isExpanded = model.isExpanded
    }

}

// MARK: - Configuration

private extension FoldableTableViewCell {

    func setupInitialState() {
        selectionStyle = .none
        arrowImageView.image = #imageLiteral(resourceName: "upArrow")
    }

}
