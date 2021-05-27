//
//  HeightCollectionCellGenerator.swift
//  ReactiveDataDisplayManager
//
//  Created by Alexander Filimonov on 02/03/2020.
//  Copyright © 2020 Александр Кравченков. All rights reserved.
//

import UIKit

/// Generator that describes collection cell generator that can returns size
@available(*, deprecated, renamed: "SizableItem")
public protocol SizableCollectionCellGenerator: AnyObject {
    func getSize() -> CGSize
}
