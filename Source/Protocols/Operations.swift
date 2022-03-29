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

public extension HeaderDataDisplayManager {

    static func += (left: Self, right: HeaderGeneratorType) {
        left.addSectionHeaderGenerator(right)
    }

}

public extension FooterDataDisplayManager {

    static func += (left: Self, right: FooterGeneratorType) {
        left.addSectionFooterGenerator(right)
    }

}
