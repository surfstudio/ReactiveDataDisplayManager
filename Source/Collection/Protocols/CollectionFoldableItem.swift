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
    var didFoldEvent: BaseEvent<Bool> { get }
    var isExpanded: Bool { get set }
    var childGenerators: [CollectionCellGenerator] { get set }
}

public extension CollectionFoldableItem {
    var labelStrategy: AccessibilityStringStrategy { .ignored }
    var traitsStrategy: AccessibilityTraitsStrategy { childGenerators.isEmpty ? .ignored : .just(.button) }
}
