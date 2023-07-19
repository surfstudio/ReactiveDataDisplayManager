//
//  SelectableItem.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 20.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

/// Protocol for `Generator` to handle didSelect event
public protocol SelectableItem: AnyObject {

    /// Invokes when user taps on the item. Requires .selectable plugin!!!
    var didSelectEvent: EmptyEvent { get }
    /// Called when the user takes their finger off the element. Requires .selectable plugin!!!
    var didDeselectEvent: EmptyEvent { get }

    /// A Boolean value that determines whether to perform a cell deselect.
    ///
    /// If the value of this property is **true** (the default), cells deselect
    /// immediately after tap. If you set it to **false**, they don't deselect.
    var isNeedDeselect: Bool { get set }
}
