//
//  TableMovable.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 12.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit
import Foundation

public typealias TableMovable = TableFeaturePlugin & TableMovableDataSource & TableMovableDelegate

public protocol TableMovableDataSource {
    func canMoveRow(at indexPath: IndexPath, with provider: TableGeneratorsProvider?) -> Bool
    func moveRow(at sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath, with provider: TableGeneratorsProvider?)
}

public protocol TableMovableDelegate {
    func canFocusRow(at indexPath: IndexPath, with provider: TableGeneratorsProvider?) -> Bool
}
