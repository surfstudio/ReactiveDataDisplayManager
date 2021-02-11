//
//  FeaturePlugin.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 10.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

public protocol FeaturePlugin { }

public protocol TableSectionTitleDisplayable: FeaturePlugin {
    func numberOfSections(with provider: TableGeneratorsProvider?) -> Int
    func sectionIndexTitles(with provider: TableGeneratorsProvider?) -> [String]?
    func sectionForSectionIndexTitle(_ title: String, at index: Int, with provider: TableGeneratorsProvider?) -> Int
}

public protocol TableMovable: FeaturePlugin {
    func canMoveRow(at indexPath: IndexPath, with provider: TableGeneratorsProvider?) -> Bool
    func moveRow(at sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath, with provider: TableGeneratorsProvider?)
    func canFocusRow(at indexPath: IndexPath, with provider: TableGeneratorsProvider?) -> Bool
}
