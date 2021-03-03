//
//  CalculatableSizeItem.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 20.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

/// Protocol for calculating height of element according to the model
public protocol CalculatableHeightItem: ConfigurableItem {
    static func getHeight(forWidth width: CGFloat, with model: Model) -> CGFloat
}

/// Protocol for calculating width of element according to the model
public protocol CalculatableWidthItem: ConfigurableItem {
    static func getWidth(forHeight height: CGFloat, with model: Model) -> CGFloat
}
