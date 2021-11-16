//
//  RectangleColorCollectionViewCell.swift
//  ReactiveDataDisplayManagerExample_iOS
//
//  Created by porohov on 15.11.2021.
//

import UIKit
import ReactiveDataDisplayManager

final class RectangleColorCollectionViewCell: UICollectionViewCell, ConfigurableItem {

    // MARK: - @IBOutlets

    @IBOutlet private weak var colorView: UIView!

    // MARK: - ConfigurableItem

    func configure(with model: UIColor) {
        colorView.backgroundColor = model
        colorView.layer.cornerRadius = 20
    }

}
