//
//  FocusableAlign.swift
//  Pods
//
//  Created by porohov on 17.11.2021.
//

import UIKit

/// Configure focusable align
public enum FocusableAlign<CollectionType> {

    /// Align left.
    /// Supported UICollectionView only
    case left

    /// Align right
    /// Supported UICollectionView only
    case right

    /// Align top
    case top

    /// Align bottom
    case bottom

    /// Align center
    /// Default [.centeredHorizontally, .centeredVertically] for UICollectionView
    case center(UICollectionView.ScrollPosition? = nil)

}

extension FocusableAlign where CollectionType == UITableView {

    func getPosition() -> UITableView.ScrollPosition {
        switch self {
        case .top:
            return .top
        case .bottom:
            return .bottom
        case .center:
            return .middle
        default:
            return .none
        }
    }

}

extension FocusableAlign where CollectionType == UICollectionView {

    func getPosition() -> UICollectionView.ScrollPosition {
        switch self {
        case .top:
            return .top
        case .bottom:
            return .bottom
        case .center(let position):
            return position ?? [.centeredHorizontally, .centeredVertically]
        case .left:
            return .left
        case .right:
            return .right
        }
    }

}
