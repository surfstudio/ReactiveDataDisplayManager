// 
//  Focusable.swift
//  Pods
//
//  Created by Olesya Tranina on 06.07.2021.
//  
//

import Foundation
import UIKit

public protocol Focusable {
    associatedtype DelegateType: FocusableDelegate

    var delegate: DelegateType { get set }
}

public protocol FocusableDelegate {
    associatedtype Provider: GeneratorsProvider
    associatedtype CollectionType

    /// Asks whether the item at the specified index path can be focused
    /// - parameters:
    ///     - at: index path of the focused item
    ///     - with: current provider with generators
    func canFocusRow(at indexPath: IndexPath, with provider: Provider?) -> Bool

    ///  Customization of the selected cell
    ///  - Parameters:
    ///     - previusView: previus view
    ///     - nextView: next view
    ///     - collectionView: default value nil, needed to center the selected cell
    ///     - tableView: default value nil, needed to center the selected cell
    func didFocusedCell(previusView: UIView?, nextView: UIView?,
                        indexPath: IndexPath?,
                        collection: CollectionType)
}
