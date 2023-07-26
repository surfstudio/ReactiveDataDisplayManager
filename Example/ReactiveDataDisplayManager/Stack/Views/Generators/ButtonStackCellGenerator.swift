//
//  ButtonStackCellGenerator.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Никита Коробейников on 27.05.2021.
//

import ReactiveDataDisplayManager
import UIKit

final class ButtonStackCellGenerator: ViewGenerator {

    // MARK: - Nested

    struct Model {
        let title: String
        let titleColor: UIColor?
        let backgroundColor: UIColor?
    }

    typealias Action = () -> Void

    // MARK: - Properties

    private let model: Model
    private let action: Action

    // MARK: - Initialization

    init(model: Model, action: @escaping Action) {
        self.model = model
        self.action = action
    }

}

// MARK: - ViewBuilder

extension ButtonStackCellGenerator: ViewBuilder {

    func build(view: UIButton) {

        view.setTitle(model.title, for: .normal)
        view.setTitleColor(model.titleColor, for: .normal)
        view.backgroundColor = model.backgroundColor

        view.addTarget(self, action: #selector(onTapped), for: .touchUpInside)
    }

}

// MARK: - Action

@objc
private extension ButtonStackCellGenerator {

    func onTapped() {
        action()
    }

}
