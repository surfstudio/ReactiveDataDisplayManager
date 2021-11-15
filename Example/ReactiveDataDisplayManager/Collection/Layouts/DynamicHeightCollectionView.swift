//
//  DynamicHeightCollectionView.swift
//  ReactiveDataDisplayManagerExample_iOS
//
//  Created by porohov on 15.11.2021.
//

import UIKit

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
