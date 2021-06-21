//
//  TableMovable.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 12.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit
import Foundation

@available(iOS, deprecated, renamed: "MovablePlugin")
public typealias TableMovable = TableFeaturePlugin & TableMovableDataSource & TableMovableDelegate

@available(iOS, deprecated, renamed: "MovableDataSource")
public protocol TableMovableDataSource {
    func canMoveRow(at indexPath: IndexPath, with provider: TableGeneratorsProvider?) -> Bool
    func moveRow(at sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath, with provider: TableGeneratorsProvider?)
}

@available(iOS, deprecated, renamed: "MovableDelegate")
public protocol TableMovableDelegate {
    func canFocusRow(at indexPath: IndexPath, with provider: TableGeneratorsProvider?) -> Bool
}
