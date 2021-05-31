//
//  DifferenceTableGenerator.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 12.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import Foundation
import ReactiveDataDisplayManager

class DifferenceTableGenerator: BaseCellGenerator<TitleTableViewCell>, RDDMDifferentiable {

    // MARK: - RDDMDifferentiable

    var differentiableItem = DifferentiableItem()

}
