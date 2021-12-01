//
//  TransformFocusableStrategy.swift
//  ReactiveDataDisplayManager
//
//  Created by porohov on 01.12.2021.
//

import UIKit

/// Allow transformation on focus
public final class TransformFocusableStrategy<CollectionType>: FocusableStrategy<CollectionType> {

    // MARK: - Private Properties

    var model: FocusedPluginTransformModel

    // MARK: - Initialization

    public init(model: FocusedPluginTransformModel) {
        self.model = model
    }

    // MARK: - FocusableStrategy

    // Configure transform
    override func didUpdateFocus(previusView: UIView?,
                                 nextView: UIView?,
                                 indexPath: IndexPath?,
                                 collection: CollectionType? = nil) {
        UIView.animate(withDuration: model.transformDuration, animations: {
            previusView?.transform = .identity
            nextView?.transform = self.model.transform
        })
    }

}
