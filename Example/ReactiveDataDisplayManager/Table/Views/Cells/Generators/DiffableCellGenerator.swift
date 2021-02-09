//
//  DiffableCellGenerator.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 04.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import ReactiveDataDisplayManager

final class DiffableCellGenerator {

    // MARK: - Private Properties

    private let model: String

    // MARK: - Initialization

    public init(model: String) {
        self.model = model
    }

}

// MARK: - TableCellGenerator

extension DiffableCellGenerator: TableCellGenerator, Diffable {

    var item: DiffableItem {
        return DiffableItem(identifier: model)
    }

    var identifier: String {
        return String(describing: TitleTableViewCell.self)
    }

}

// MARK: - ViewBuilder

extension DiffableCellGenerator: ViewBuilder {

    func build(view: TitleTableViewCell) {
        view.fill(with: model)
    }

}
