//
//  TableSectionTitleDisplayable.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 12.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

public protocol TableSectionTitleDisplayable: TableFeaturePlugin {
    func numberOfSections(with provider: TableGeneratorsProvider?) -> Int
    func sectionIndexTitles(with provider: TableGeneratorsProvider?) -> [String]?
    func sectionForSectionIndexTitle(_ title: String, at index: Int, with provider: TableGeneratorsProvider?) -> Int
}
