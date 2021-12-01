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

    public init(position: FocusableAlign<UICollectionView>) {
        self.position = position.getPosition()
    }

    // MARK: - FocusableStrategy

    // Configure scroll item
    override func didUpdateFocus(previusView: UIView?,
                                 nextView: UIView?,
                                 indexPath: IndexPath?,
                                 collection: UICollectionView?) {
        guard let index = indexPath else {
            return
        }
        collection?.scrollToItem(at: index, at: position, animated: true)
    }

}
