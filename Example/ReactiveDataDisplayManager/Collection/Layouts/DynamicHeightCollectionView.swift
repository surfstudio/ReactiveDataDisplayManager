//
//  DynamicHeightCollectionView.swift
//  ReactiveDataDisplayManagerExample_iOS
//
//  Created by porohov on 15.11.2021.
//

import UIKit

/// This UICollectionView allows you to bind the height of the collection to the height of the content.
/// Such a collection can be put into a table cell and called layoutIfNeeded after the collection has been populated.
/// Does not work in ios 15
class DynamicHeightCollectionView: UICollectionView {

    override func layoutSubviews() {
        super.layoutSubviews()
        if !__CGSizeEqualToSize(bounds.size, intrinsicContentSize) {
            self.invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        return contentSize
    }

}
