//
//  CompositFocusableTableStrategy.swift
//  ReactiveDataDisplayManager
//
//  Created by porohov on 01.12.2021.
//

import UIKit

/// Many strategies can be combined in this strategy
public final class CompositeFocusableStrategy<CollectionType>: FocusableStrategy<CollectionType> {

    // MARK: - Private Properties

    private var strategys: [FocusableStrategy<CollectionType>]

    // MARK: - Initialization

    /// Takes an array of type FocusableStrategy <CollectionType>
    public init(strategys: [FocusableStrategy<CollectionType>]) {
        self.strategys = strategys
    }

    // MARK: - FocusableStrategy

    // Configure strategys
    override public func didUpdateFocus(previusView: UIView?,
                                        nextView: UIView?,
                                        indexPath: IndexPath?,
                                        collection: CollectionType?) {
        strategys.forEach {
            $0.didUpdateFocus(previusView: previusView,
                              nextView: nextView,
                              indexPath: indexPath,
                              collection: collection)
        }
    }

}
