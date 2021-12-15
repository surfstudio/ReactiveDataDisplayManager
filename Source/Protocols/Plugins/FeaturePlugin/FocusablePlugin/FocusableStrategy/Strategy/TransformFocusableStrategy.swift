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

    /// Takes a FocusedPluginTransformModel
    public init(model: FocusedPluginTransformModel) {
        self.model = model
    }

    // MARK: - FocusableStrategy

    // Configure transform
    override public func didUpdateFocus(previusView: UIView?,
                                        nextView: UIView?,
                                        indexPath: IndexPath?,
                                        collection: CollectionType? = nil) {
        UIView.animate(withDuration: model.duration, delay: model.delay, animations: {
            previusView?.transform = .identity
            nextView?.transform = self.model.transform
        })
    }

}
