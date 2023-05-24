//
//  Animator.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 11.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

/// Entity to animate specific collection operations like insert or remove rows
open class Animator<Collection: UIView> {

    public typealias Operation = () -> Void

    public init() { }

    /// Perform animation block.
    /// For example. Insert, or delete rows of collecton
    /// - parameter collection: Collection containing animating rows
    /// - parameter animated: Should execute operation animated?
    /// - parameter operation: Operation block. Might be any operation with collection.
    func perform(in collection: Collection, animated: Bool, operation: Operation?) {
        if animated {
            performAnimated(in: collection, operation: operation)
        } else {
            UIView.performWithoutAnimation {
                performAnimated(in: collection, operation: operation)
            }
        }
    }

    /// Perform animation block.
    /// For example. Insert, or delete rows of collecton
    /// - parameter collection: Collection containing animating row
    /// - parameter operation: Operation block. Might be any operation with collection.
    func performAnimated(in collection: Collection, operation: Operation?) {
        preconditionFailure("\(#function) must be overriden in child")
    }

}
