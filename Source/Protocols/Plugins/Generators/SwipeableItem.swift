//
//  SwipeableItem.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 12.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

/// Protocol for `Generator` to manage `UISwipeActionsConfiguration` of generated cell
@available(iOS 11.0, tvOS 11.0, *)
public protocol SwipeableItem {

    /// Array of supported action identifiers
    ///
    /// - Note: Full list of actions  should be implemented in `TableSwipeActionsConfiguration.actions`
    var actionTypes: [String] { get set }

    /// Invokes when action is selected
    ///
    /// Parameter: identifier of action
    var didSwipeEvent: BaseEvent<String> { get }
}
