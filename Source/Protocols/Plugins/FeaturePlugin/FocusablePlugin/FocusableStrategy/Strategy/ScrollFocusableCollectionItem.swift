//
//  ScrollFocusableCollectionItem.swift
//  ReactiveDataDisplayManager
//
//  Created by porohov on 01.12.2021.
//

import UIKit

/// Scroll to when focusing
public final class ScrollFocusableCollectionItem: FocusableStrategy<UICollectionView> {

    // MARK: - Private Properties

    private var position: UICollectionView.ScrollPosition

    // MARK: - Initialization

    /// Takes a position UICollectionView.ScrollPosition
    public init(position: UICollectionView.ScrollPosition) {
        self.position = position
    }

    // MARK: - FocusableStrategy

    // Configure scroll item
    override public func didUpdateFocus(previusView: UIView?,
                                        nextView: UIView?,
                                        indexPath: IndexPath?,
                                        collection: UICollectionView?) {
        guard let index = indexPath else {
            return
        }
        collection?.scrollToItem(at: index, at: position, animated: true)
    }

}
