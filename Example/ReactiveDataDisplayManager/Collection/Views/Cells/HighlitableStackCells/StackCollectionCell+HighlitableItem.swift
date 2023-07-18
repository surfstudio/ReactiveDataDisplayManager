//
//  StackCollectionCell+HighlitableItem.swift
//  ReactiveDataDisplayManagerExample_iOS
//
//  Created by Konstantin Porokhov on 29.06.2023.
//

import ReactiveDataComponents
import ReactiveDataDisplayManager
import UIKit

extension StackCollectionCell: HighlightableItem {

    // MARK: - HighlightableItem

    public func applyUnhighlightedStyle() {
        UIView.animate(withDuration: 0.2) {
            self.contentView.backgroundColor = .white
        }
    }

    public func applyHighlightedStyle() {
        UIView.animate(withDuration: 0.2) {
            self.contentView.backgroundColor = .lightGray.withAlphaComponent(0.3)
        }
    }

}
