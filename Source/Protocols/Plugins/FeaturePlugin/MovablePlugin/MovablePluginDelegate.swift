//
//  MovablePluginDelegate.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 15.04.2021.
//

import Foundation
import UIKit

/// Delegate based on `MovableDelegate` protocol.
open class MovablePluginDelegate<Provider: SectionsProvider> {

    // MARK: - Typealias

    public typealias GeneratorType = MovableItem

}

// MARK: - MovableDelegate

extension MovablePluginDelegate: MovableDelegate {

    /// Asks whether the item at the specified index path can be focused
    /// - parameters:
    ///     - at: index path of the focused item
    ///     - with: current provider with generators
    open func canFocusRow(at indexPath: IndexPath, with provider: Provider?) -> Bool {
        if let generator = provider?.sections[indexPath.section].generators[indexPath.row] as? GeneratorType {
            return generator.canMove()
        }
        return false
    }

}
