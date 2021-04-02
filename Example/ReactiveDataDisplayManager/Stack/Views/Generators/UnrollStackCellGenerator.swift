//
//  UnrollCellGenerator.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Dmitry Korolev on 02.04.2021.
//

import ReactiveDataDisplayManager

final class UnrollStackCellGenerator: StackCellGenerator {

    // MARK: - Properties

    var bigText: String

    // MARK: - Initialization

    init(with bigText: String) {
        self.bigText = bigText
    }

}

// MARK: - ViewBuilder

extension UnrollStackCellGenerator: ViewBuilder {

    func build(view: UnrollCellStackView) {
        view.configure(with: bigText)
    }

}
