//
//  RectangleColorCollectionViewCell.swift
//  ReactiveDataDisplayManagerExample_iOS
//
//  Created by porohov on 15.11.2021.
//

import UIKit
import ReactiveDataDisplayManager

final class RectangleColorCollectionViewCell: UICollectionViewCell, ConfigurableItem, AccessibilityItem {

    // MARK: - @IBOutlets

    @IBOutlet private weak var colorView: UIView!

    // MARK: - AccessibilityItem

    var labelStrategy: AccessibilityStringStrategy = .ignored

    // MARK: - ConfigurableItem

    func configure(with model: UIColor) {
        colorView.backgroundColor = model
        if #available(iOS 14.0, *) {
            labelStrategy = .just(model.accessibilityName)
        } else {
            labelStrategy = .just("some color")
        }
        colorView.layer.cornerRadius = 20
    }

}
