//
//  Modifier.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 04.03.2021.
//

import UIKit

/// Helper class to modify view subviews or cells
open class Modifier<View: UIView, Animation> {

    public typealias AnimationGroup = (remove: Animation, insert: Animation)

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
    open func reloadRows(at indexPaths: [IndexPath], with updateAnimation: Animation?) {
        preconditionFailure("\(#function) must be overriden in child")
    }

    /// Reload specific set of sections with animation
    ///
    /// - parameter indexPaths: location of sections to update
    /// - parameter updateAnimation: animation of update  operation
    open func reloadSections(at indexPaths: IndexSet, with updateAnimation: Animation?) {
        preconditionFailure("\(#function) must be overriden in child")
    }

    /// Replace specific subview to new subview with animation
    ///
    /// - parameter indexPath: location of subview to replace
    /// - parameter animation: group of animations to remove and insert operation
    open func replace(at indexPath: IndexPath, with animation: AnimationGroup?) {
        preconditionFailure("\(#function) must be overriden in child")
    }

    /// Replace row at specified indexPath
    ///
    /// - parameters:
    ///     - parameter indexPaths: array with index of removed row
    ///     - parameter insertIndexPaths: array with index of inserted row
    ///     - parameter animation: group of animations to remove and insert operation
    open func replace(at indexPaths: [IndexPath],
                      on insertIndexPaths: [IndexPath],
                      with animation: AnimationGroup?) {
        preconditionFailure("\(#function) must be overriden in child")
    }

    /// Insert new sections with rows at specific position with animation
    ///
    /// - parameter indexDictionary: dictionary where **key** is new section index and value is location of subviews to insert
    /// - parameter insertAnimation: animation of insert operation
    ///  - Warning: make sure that you do not have mistake in indexes inside `indexDictionary`.
    ///  For example, if you are inserting **many sections** using this method you should notice that **index** cannot be greater than **final number of sections**.
    open func insertSectionsAndRows(at indexDictionary: [Int: [IndexPath]], with insertAnimation: Animation?) {
        preconditionFailure("\(#function) must be overriden in child")
    }

    /// Insert new sections at specific position with animation
    ///
    /// - parameter indexPaths: location of sections to insert
    /// - parameter insertAnimation: animation of insert operation
    ///  - Warning: This method will insert an **empty** section only. If you need to insert section with rows use `insertSectionsAndRows: [Int : [IndexPath]]` instead.
    open func insertSections(at indexPaths: IndexSet, with insertAnimation: Animation?) {
        preconditionFailure("\(#function) must be overriden in child")
    }

    /// Insert new subviews at specific position with animation
    ///
    /// - parameter indexPaths: location of subviews to insert
    /// - parameter insertAnimation: animation of insert operation
    open func insertRows(at indexPaths: [IndexPath], with insertAnimation: Animation?) {
        preconditionFailure("\(#function) must be overriden in child")
    }

    /// Remove subviews at specific position with animation
    ///
    /// - parameter indexPaths: location of subviews to remove
    /// - parameter removeAnimation: animation of remove operation
    open func removeRows(at indexPaths: [IndexPath], and section: IndexSet?, with removeAnimation: Animation?) {
        preconditionFailure("\(#function) must be overriden in child")
    }
}
