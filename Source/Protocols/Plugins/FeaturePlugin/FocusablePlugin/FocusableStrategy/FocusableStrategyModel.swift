//
//  FocusableStrategyModel.swift
//  ReactiveDataDisplayManager
//
//  Created by porohov on 01.12.2021.
//

import UIKit

struct FocusableStrategyModel<CollectionType> {
    let previusView: UIView?
    let nextView: UIView?
    let indexPath: IndexPath?
    var collection: CollectionType?

    public init(previusView: UIView?,
                nextView: UIView?,
                indexPath: IndexPath?,
                collection: CollectionType? = nil) {
        self.previusView = previusView
        self.nextView = nextView
        self.indexPath = indexPath
        self.collection = collection
    }
}
