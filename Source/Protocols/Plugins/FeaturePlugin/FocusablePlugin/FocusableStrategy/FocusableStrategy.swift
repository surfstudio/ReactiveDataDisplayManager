//
//  FocusableStrategy.swift
//  Pods
//
//  Created by porohov on 18.11.2021.
//

import UIKit

open class FocusableStrategy<CollectionType> {

    ///  Customization of the selected cell
    ///  - Parameters:
    ///     - previusView: previus view
    ///     - nextView: next view
    ///     - collection: needed to center the selected cell, customize border for UITableView
    func didUpdateFocus(previusView: UIView?,
                        nextView: UIView?,
                        indexPath: IndexPath?,
                        collection: CollectionType? = nil) {
        preconditionFailure("")
    }

}
