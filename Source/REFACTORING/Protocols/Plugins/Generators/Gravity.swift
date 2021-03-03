//
//  GravityItem.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 20.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

public protocol GravityItem: AnyObject {
    var heaviness: Int { get set }
    func getHeaviness() -> Int
}
