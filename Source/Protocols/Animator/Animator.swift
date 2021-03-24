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

    /// Perform animation block.
    /// For example. Insert, or delete rows of collecton
    /// - Parameters:
    ///     - collection: Collection containing animating rows
    ///     - animation: Animation block
    func perform(in collection: Collection, animation: () -> Void) {}
}
