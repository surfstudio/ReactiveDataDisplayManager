//
//  MovableCellGenerator.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 02.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import Foundation
import ReactiveDataDisplayManager

final class MovableCellGenerator: MovableGenerator {

    // MARK: - Private Properties

    private let model: String

    // MARK: - Initialization

    public init(model: String) {
        self.model = model
    }

}

// MARK: - TableCellGenerator

extension MovableCellGenerator: TableCellGenerator {

    var identifier: String {
        return String(describing: TitleTableViewCell.self)
    }

}

// MARK: - ViewBuilder

extension MovableCellGenerator: ViewBuilder {

    func build(view: TitleTableViewCell) {
        view.fill(with: model)
    }

}
