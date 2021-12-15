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
    ///     - previusView: previus view optional value
    ///     - nextView: next view optional value
    ///     - indexPath: IndexPath optional value
    ///     - collection: needed to center the selected cell, customize border for UITableView
    func didUpdateFocus(previusView: UIView?,
                        nextView: UIView?,
                        indexPath: IndexPath?,
                        collection: CollectionType)
}
