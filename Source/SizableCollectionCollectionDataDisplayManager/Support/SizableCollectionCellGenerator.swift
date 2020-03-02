//
//  HeightCollectionCellGenerator.swift
//  ReactiveDataDisplayManager
//
//  Created by Alexander Filimonov on 02/03/2020.
//  Copyright © 2020 Александр Кравченков. All rights reserved.
//

import Foundation

public protocol SizableCollectionCellGenerator: class {
    func getSize() -> CGSize
}
