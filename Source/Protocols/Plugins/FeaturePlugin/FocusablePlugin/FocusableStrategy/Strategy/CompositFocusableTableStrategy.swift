//
//  CompositFocusableTableStrategy.swift
//  ReactiveDataDisplayManager
//
//  Created by porohov on 01.12.2021.
//

import UIKit

public final class CompositFocusableStrategy<CollectionType>: FocusableStrategy<CollectionType> {

    // MARK: - Private Properties

    private var strategys: [FocusableStrategy<CollectionType>]

    // MARK: - Initialization

    public init(strategys: [FocusableStrategy<CollectionType>]) {
        self.strategys = strategys
    }

    // MARK: - FocusableStrategy

    override func didUpdateFocus(previusView: UIView?,
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
