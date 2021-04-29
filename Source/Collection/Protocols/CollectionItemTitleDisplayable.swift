//
//  CollectionItemTitleDisplayable.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 18.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit
import Foundation

public protocol CollectionItemTitleDisplayable: CollectionFeaturePlugin {
    func indexTitles(with provider: CollectionGeneratorsProvider?) -> [String]?
    func indexPathForIndexTitle(_ title: String, at index: Int, with provider: CollectionGeneratorsProvider?) -> IndexPath
}
