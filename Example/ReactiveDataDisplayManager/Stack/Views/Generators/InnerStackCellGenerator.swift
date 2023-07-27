//
//  InnerStackCellGenerator.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Dmitry Korolev on 02.04.2021.
//

import UIKit
import ReactiveDataDisplayManager

final class InnerStackCellGenerator: ViewGenerator {

    // MARK: - Model

    struct Model {
        let axis: NSLayoutConstraint.Axis
        let alignment: UIStackView.Alignment
        let distribution: UIStackView.Distribution
        let spacing: CGFloat
    }

    // MARK: - Properties

    private let model: Model
    private let children: [ViewGenerator]

    // MARK: - Initialization

    init(model: Model, children: [ViewGenerator]) {
        self.model = model
        self.children = children
    }

}

// MARK: - ViewBuilder

extension InnerStackCellGenerator: ViewBuilder {

    func build(view: UIStackView) {

        view.axis = model.axis
        view.alignment = model.alignment
        view.distribution = model.distribution
        view.spacing = model.spacing

        let adapter = view.rddm.baseBuilder
            .build()

        adapter += children

        adapter => .reload
    }
}
