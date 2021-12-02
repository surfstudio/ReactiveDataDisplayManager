//
//  ShadowFocusableStrategy.swift
//  ReactiveDataDisplayManager
//
//  Created by porohov on 01.12.2021.
//

import UIKit

/// Apply shadows on focus
public final class ShadowFocusableStrategy<CollectionType>: FocusableStrategy<CollectionType> {

    // MARK: - Private Properties

    private var model: FocusedPluginShadowModel

    // MARK: - Initialization

    /// Takes a FocusedPluginShadowModel
    public init(model: FocusedPluginShadowModel) {
        self.model = model
    }

    // MARK: - FocusableStrategy

    // Configure shadow
    override public func didUpdateFocus(previusView: UIView?,
                                        nextView: UIView?,
                                        indexPath: IndexPath?,
                                        collection: CollectionType? = nil) {
        previusView?.layer.shadowRadius = .zero
        previusView?.layer.shadowOpacity = .zero
        nextView?.layer.shadowColor = model.color.cgColor
        nextView?.layer.shadowRadius = model.radius
        nextView?.layer.shadowOpacity = model.opacity
        nextView?.layer.shadowOffset = model.offset
    }

}
