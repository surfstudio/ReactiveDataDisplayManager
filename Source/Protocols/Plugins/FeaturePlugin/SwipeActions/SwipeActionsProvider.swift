//
//  SwipeActionsProvider.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 19.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//
#if os(iOS)
import UIKit

// sourcery: AutoMockable
@available(iOS 11.0, *)
public protocol SwipeActionsProvider {
    var isEnableSwipeActions: Bool { get set }

    func getLeadingSwipeActionsForGenerator(_ generator: SwipeableItem) -> SwipeActionsConfiguration?
    func getTrailingSwipeActionsForGenerator(_ generator: SwipeableItem) -> SwipeActionsConfiguration?
}
#endif
