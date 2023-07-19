//
//  StackCollectionCell.swift
//  ReactiveDataDisplayManager
//
//  Created by Konstantin Porokhov on 29.06.2023.
//

import UIKit
import ReactiveDataDisplayManager

/// Cell - container with horizontal layout. Accepts generators of other cells, creates a single press state for them
open class StackCollectionCell: UICollectionViewCell, ConfigurableItem, ExpandableItem {

    // MARK: - ExpandableItem

    public var onHeightChanged = ReactiveDataDisplayManager.InputEvent<CGFloat?>()
    public var animatedExpandable = true

    // MARK: - Public methods

    public func configure(with model: UIView) {
        guard !contentView.contains(model) else {
            if contentView.frame != model.frame {
                onHeightChanged.invoke(with: nil)
            }
            return
        }
        model.attach(to: contentView)
        onHeightChanged.invoke(with: nil)
    }

}
