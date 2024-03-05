//
//  UnrollCellGenerator.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Dmitry Korolev on 02.04.2021.
//

import ReactiveDataDisplayManager

final class UnrollStackCellGenerator: ViewGenerator {

    // MARK: - Properties

    private let bigText: String

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
