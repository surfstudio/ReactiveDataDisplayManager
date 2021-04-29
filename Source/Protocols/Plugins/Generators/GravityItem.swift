//
//  GravityItem.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 20.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

/// Protocol for `Generator` to describe order position of generated cell
public protocol GravityItem: AnyObject {

    /// Order in list.
    /// - Note: Less is higher.
    var heaviness: Int { get set }

    /// Geter of heaviness
    func getHeaviness() -> Int
}
