//
//  MovableCellGenerator.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 02.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import Foundation
import ReactiveDataDisplayManager

class MovableCellGenerator: BaseCellGenerator<TitleTableViewCell>, MovableItem {

    // MARK: - Properties

    var id: Int

    // MARK: - Initialization

    init(id: Int, model: String) {
        self.id = id
        super.init(with: model)
    }

}
