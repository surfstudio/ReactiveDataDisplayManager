//
//  Modifier.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 04.03.2021.
//

import UIKit

/// Helper class to modify view subviews or cells
open class Modifier<View: UIView, Animation> {

    public private(set) weak var view: View?

    /// - parameter view: View which contains subviews or cells
    public init(view: View) {
        self.view = view
    }

    /// Reload all subviews without any animation
    open func reload() {
        preconditionFailure("\(#function) must be overriden in child")
    }

    /// Reload specific set of subviews with animation
    ///
    /// - parameter indexPaths: location of subviews to update
    /// - parameter updateAnimation: animation of update  operation
    open func reloadRows(at indexPaths: [IndexPath], with updateAnimation: Animation) {
        preconditionFailure("\(#function) must be overriden in child")
    }

    /// Reload specific set of sections with animation
    ///
    /// - parameter indexPaths: location of sections to update
    /// - parameter updateAnimation: animation of update  operation
    open func reloadSections(at indexPaths: IndexSet, with updateAnimation: Animation) {
        preconditionFailure("\(#function) must be overriden in child")
    }

    /// Replace specific subview to new subview with animation
    ///
    /// - parameter indexPath: location of subview to replace
    /// - parameter removeAnimation: animation of remove operation
    /// - parameter insertAnimation: animation of insert operation
    open func replace(at indexPath: IndexPath, with removeAnimation: Animation, and insertAnimation: Animation) {
        preconditionFailure("\(#function) must be overriden in child")
    }

    /// Insert new sections at specific position with animation
    ///
    /// - parameter indexPaths: location of sections to insert
    /// - parameter insertAnimation: animation of insert operation
    open func insertSections(at indexPaths: IndexSet, with insertAnimation: Animation) {
        preconditionFailure("\(#function) must be overriden in child")
    }

    /// Insert new subviews at specific position with animation
    ///
    /// - parameter indexPaths: location of subviews to insert
    /// - parameter insertAnimation: animation of insert operation
    open func insertRows(at indexPaths: [IndexPath], with insertAnimation: Animation) {
        preconditionFailure("\(#function) must be overriden in child")
    }

    /// Remove subviews at specific position with animation
    ///
    /// - parameter indexPaths: location of subviews to remove
    /// - parameter removeAnimation: animation of remove operation
    open func removeRows(at indexPaths: [IndexPath], and section: IndexSet?, with removeAnimation: Animation) {
        preconditionFailure("\(#function) must be overriden in child")
    }
}
