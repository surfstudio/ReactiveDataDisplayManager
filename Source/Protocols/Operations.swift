//
//  Operations.swift
//  ReactiveDataDisplayManager
//
//  Created by Alexander Kravchenkov on 09.02.2018.
//  Copyright © 2018 Александр Кравченков. All rights reserved.
//

import UIKit

extension DataDisplayManager {
    static func += (left: Self, right: GeneratorType) {
        left.addCellGenerator(right)
    }

    static func += (left: Self, right: [GeneratorType]) {
        left.addCellGenerators(right)
    }
}
