//
//  DisplayableItem.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 20.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

/// Protocol for `Generator` to handle cells display events
public protocol DisplayableItem: AnyObject {

    /// Invokes when cell will displaying.
    var willDisplayEvent: BaseEvent<Void> { get }

    /// Invokes when cell did end displaying.
    var didEndDisplayEvent: BaseEvent<Void> { get }

    /// Invokes when cell did end displaying. (Replacement for didEndDisplayEvent:; makes cell management easier.)
    /// To be clear, it is just a workaround.
    var didEndDisplayCellEvent: BaseEvent<UITableViewCell>? { get }

}
