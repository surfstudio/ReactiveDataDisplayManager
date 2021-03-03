//
//  DisplayableItem.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 20.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

public protocol DisplayableItem: class {

    /// Invokes when cell will displaying.
    var willDisplayEvent: BaseEvent<Void> { get }

    /// SORTA DEPRECATED
    /// Invokes when cell did end displaying.
    var didEndDisplayEvent: BaseEvent<Void> { get }

    /// Invokes when cell did end displaying. (Replacement for didEndDisplayEvent:; makes cell management easier.)
    /// To be clear, it is just a workaround.
    var didEndDisplayCellEvent: BaseEvent<UITableViewCell>? { get }

}
