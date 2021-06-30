//
//  SwipeActionsConfiguration.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 12.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

#if os(iOS)

import Foundation
import UIKit

@available(iOS 11.0, *)
public struct SwipeActionsConfiguration {

    // MARK: - Properties

    public let actions: [SwipeAction]
    public let performsFirstActionWithFullSwipe: Bool

    // MARK: - Initialization

    public init(actions: [SwipeAction],
                performsFirstActionWithFullSwipe: Bool = true) {
        self.actions = actions
        self.performsFirstActionWithFullSwipe = performsFirstActionWithFullSwipe
    }

}

@available(iOS 11.0, *)
public struct SwipeAction {

    // MARK: - Properties

    public let title: String?
    public let backgroundColor: UIColor?
    public let view: UIView?
    public let image: UIImage?
    public let type: String
    public let style: UIContextualAction.Style

    // MARK: - Initialization

    public init(title: String? = nil,
                backgroundColor: UIColor?,
                view: UIView? = nil,
                image: UIImage? = nil,
                type: String,
                style: UIContextualAction.Style) {
        self.title = title
        self.backgroundColor = backgroundColor
        self.view = view
        self.image = image
        self.type = type
        self.style = style
    }

}
#endif
