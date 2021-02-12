//
//  TableMovable.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 12.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import Foundation

public protocol TableMovable: FeaturePlugin {
    func canMoveRow(at indexPath: IndexPath, with provider: TableGeneratorsProvider?) -> Bool
    func moveRow(at sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath, with provider: TableGeneratorsProvider?)
    func canFocusRow(at indexPath: IndexPath, with provider: TableGeneratorsProvider?) -> Bool
}
