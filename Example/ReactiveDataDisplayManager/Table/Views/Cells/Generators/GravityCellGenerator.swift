//
//  GravityCellGenerator.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 03.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import ReactiveDataDisplayManager

class GravityCellGenerator: BaseCellGenerator<TitleTableViewCell> {

    // MARK: - Properties

    var heaviness: Int

    // MARK: - Intialization

    init(model: String, heaviness: Int = .zero) {
        self.heaviness = heaviness
        super.init(with: model)
    }

}

// MARK: - Gravity

extension GravityCellGenerator: GravityItem {

    func getHeaviness() -> Int {
        return heaviness
    }

}
