//
//  RDDMSwipeableItem.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 12.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
public protocol RDDMSwipeableItem {
    var actionTypes: [String] { get set }
    var didSwipeEvent: BaseEvent<String> { get }
}
