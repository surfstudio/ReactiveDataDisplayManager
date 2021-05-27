//
//  SizableItem.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 20.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

/// Protocol for `Generator` to describe cell size
public protocol SizableItem: class {

    /// Prefered size of cell
    func getSize() -> CGSize
}
