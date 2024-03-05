//
//  FoldableItem.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 20.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

/// Protocol for cells to handle `isExpanded` state
public protocol FoldableStateHolder: AnyObject {
    func setExpanded(_ isExpanded: Bool)
}

public protocol FoldableStateToggling {
    func toggleEpanded()
}

/// Protocol for `TableCellGenerator` to manage expand/collapse state
public protocol FoldableItem: AnyObject {

    /// Invokes when cell `didSelect`
    var didFoldEvent: Event<Bool> { get }

    /// `true` if cell where expanded, `false` if cell where collapsed
    var isExpanded: Bool { get set }

}
