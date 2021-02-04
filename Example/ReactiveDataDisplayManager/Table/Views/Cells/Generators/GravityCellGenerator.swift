//
//  GravityCellGenerator.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 03.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import ReactiveDataDisplayManager

final class GravityCellGenerator {

    // MARK: - Properties

    var heaviness: Int

    // MARK: - Private Properties

    private let model: String

    // MARK: - Initialization

    public init(model: String, heaviness: Int = .zero) {
        self.heaviness = heaviness
        self.model = model
    }

}

// MARK: - TableCellGenerator

extension GravityCellGenerator: GravityTableCellGenerator {

    var identifier: String {
        return String(describing: TitleTableViewCell.self)
    }

    func getHeaviness() -> Int {
        return heaviness
    }

}

// MARK: - ViewBuilder

extension GravityCellGenerator: ViewBuilder {

    func build(view: TitleTableViewCell) {
        view.fill(with: model)
    }

}
