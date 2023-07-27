//
//  CollectionFoldableItem.swift
//  ReactiveDataDisplayManager
//
//  Created by Vadim Tikhonov on 11.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

// sourcery: AutoMockable
public protocol CollectionFoldableItem: AnyObject, AccessibilityStrategyProvider {
    var didFoldEvent: Event<Bool> { get }
    var isExpanded: Bool { get set }
    var children: [CollectionCellGenerator] { get set }
}

public extension CollectionFoldableItem {
    var labelStrategy: AccessibilityStringStrategy { .ignored }
    var traitsStrategy: AccessibilityTraitsStrategy { children.isEmpty ? .ignored : .just(.button) }
}
