//
//  CollectionChildrenHolder.swift
//  ReactiveDataDisplayManager
//
//  Created by Vadim Tikhonov on 11.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

// sourcery: AutoMockable
public protocol CollectionChildrenHolder: AccessibilityStrategyProvider {
    var children: [CollectionCellGenerator] { get set }
}

// MARK: - Defaults

public extension CollectionChildrenHolder {
    var labelStrategy: AccessibilityStringStrategy { .ignored }
    var traitsStrategy: AccessibilityTraitsStrategy { children.isEmpty ? .ignored : .just(.button) }
}
