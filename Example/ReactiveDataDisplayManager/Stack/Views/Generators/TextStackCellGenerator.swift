//
//  TextStackViewGenerator.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Dmitry Korolev on 02.04.2021.
//

import ReactiveDataDisplayManager

final class TextStackCellGenerator: StackCellGenerator {

    // MARK: - Properties

    var title: String
    var aligned: NSTextAlignment
    var fontSize: CGFloat
    var weight: UIFont.Weight

    // MARK: - Initialization

    init(title: String, fontSize: CGFloat, aligned: NSTextAlignment = .left, weight: UIFont.Weight = .regular) {
        self.title = title
        self.aligned = aligned
        self.fontSize = fontSize
        self.weight = weight
    }

}

// MARK: - ViewBuilder

extension TextStackCellGenerator: ViewBuilder {

    func build(view: UILabel) {
        view.numberOfLines = 0
        view.text = title
        view.textAlignment = aligned
        view.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
    }

}
