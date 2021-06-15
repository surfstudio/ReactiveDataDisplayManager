//
//  TextStackViewGenerator.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Dmitry Korolev on 02.04.2021.
//

import ReactiveDataDisplayManager

final class TextStackCellGenerator: StackCellGenerator {

    // MARK: - Model

    struct Model {
        let title: String
        let alignment: NSTextAlignment
        let font: UIFont
    }

    // MARK: - Properties

    private let model: Model

    // MARK: - Initialization

    init(model: Model) {
        self.model = model
    }

}

// MARK: - ViewBuilder

extension TextStackCellGenerator: ViewBuilder {

    func build(view: UILabel) {
        view.numberOfLines = 0
        view.text = model.title
        view.textAlignment = model.alignment
        view.font = model.font
    }

}
