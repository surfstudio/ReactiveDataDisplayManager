//
//  FocusableStrategy.swift
//  Pods
//
//  Created by porohov on 18.11.2021.
//

import UIKit

/// Focus strategy in tvOS
open class FocusableStrategy<CollectionType> {

    // MARK: - Initialization

    public init() { }

    // MARK: - Open Method

    ///  Customization of the selected cell
    ///  - Parameters:
    ///     - previusView: previus view
    ///     - nextView: next view
    ///     - collection: needed to center the selected cell, customize border for UITableView
    open func didUpdateFocus(previusView: UIView?,
                        nextView: UIView?,
                        indexPath: IndexPath?,
                        collection: CollectionType? = nil) {
        preconditionFailure("\(#function) must be overriden in child")
    }

}
