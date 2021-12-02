//
//  BorderFocusableStrategy.swift
//  ReactiveDataDisplayManager
//
//  Created by porohov on 01.12.2021.
//

import UIKit

/// Apply borber on focus
///
/// Work in UITableView only
public final class BorderFocusableStrategy: FocusableStrategy<UITableView> {

    // MARK: - Private Properties

    private var model: FocusablePluginBorderModel

    // MARK: - Initialization

    /// Takes a FocusablePluginBorderModel
    public init(model: FocusablePluginBorderModel) {
        self.model = model
    }

    // MARK: - FocusableStrategy

    // Configure border
    override public func didUpdateFocus(previusView: UIView?,
                                        nextView: UIView?,
                                        indexPath: IndexPath?,
                                        collection: UITableView?) {
        guard let indexPath = indexPath else {
            return
        }
        let cell = collection?.cellForRow(at: indexPath)
        cell?.focusStyle = .custom
        previusView?.layer.borderWidth = .zero
        nextView?.layer.borderWidth = model.width
        nextView?.layer.borderColor = model.color.cgColor
        nextView?.layer.cornerRadius = model.radius
        nextView?.clipsToBounds = model.clipsToBounds
    }
}
