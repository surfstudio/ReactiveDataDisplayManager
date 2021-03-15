//
//  IndexTitleDisplaybleItem.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 10.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

/// Protocol for `HeaderGenerator` to describe index title
public protocol IndexTitleDisplaybleItem {
    /// The title as displayed in the index of tableView/collectionView
    var title: String { get }
    /// When this property is set to **true**, then the title will be displayed in the index of tableView/collectionView
    var needIndexTitle: Bool { get }
}
