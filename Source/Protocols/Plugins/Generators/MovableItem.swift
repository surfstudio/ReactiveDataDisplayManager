//
//  MovableItem.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 20.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

/// Protocol for `Generator` to describe moving strategy for cells
public protocol MovableItem: IdentifiableItem {

    /// Return **true** to enable moving of generated cell in edit mode
    func canMove() -> Bool

    /// Return  **true** to enable moving of generated cell betwen sections
    func canMoveInOtherSection() -> Bool
}

public extension MovableItem {

    var id: AnyHashable? {
        nil
    }

    func canMove() -> Bool {
        return true
    }

    func canMoveInOtherSection() -> Bool {
        return true
    }

}
