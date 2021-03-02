//
//  RDDMMovableItem.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 20.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

public protocol RDDMMovableItem {
    func canMove() -> Bool
    func canMoveInOtherSection() -> Bool
}

public extension RDDMMovableItem {

    func canMove() -> Bool {
        return true
    }

    func canMoveInOtherSection() -> Bool {
        return true
    }

}
