//
//  BaseStackManager.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Eysner on 17.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

/// Contains base implementation of DataDisplayManager with UIStackView.
open class BaseStackManager: DataDisplayManager {

    // MARK: - Typealias

    public typealias CollectionType = UIStackView
    public typealias CellGeneratorType = StackCellGenerator

    // MARK: - Properties

    public weak var view: UIStackView!
    public var generators: [StackCellGenerator]

    // MARK: - Initialization

    public init() {
        generators = []
    }

    // MARK: - DataDisplayManager

    public func forceRefill() {
        view.arrangedSubviews.forEach { $0.removeFromSuperview() }

        generators.enumerated().forEach { offset, generator in
            let subView = generator.generate(stackView: view, index: offset)
            view.addArrangedSubview(subView)
        }
    }

    public func addCellGenerator(_ generator: StackCellGenerator) {
        generators.append(generator)
    }

    public func addCellGenerators(_ generators: [StackCellGenerator], after: StackCellGenerator) {
        if let index = index(of: after) {
            generators.enumerated().forEach { offset, generator in
                self.generators.insert(generator, at: index + offset + 1)
            }
        } else {
            self.generators.append(contentsOf: generators)
        }
    }

    public func addCellGenerator(_ generator: StackCellGenerator, after: StackCellGenerator) {
        if let index = index(of: after) {
            generators.insert(generator, at: index + 1)
        } else {
            generators.append(generator)
        }
    }

    public func addCellGenerators(_ generators: [StackCellGenerator]) {
        self.generators.append(contentsOf: generators)
    }

    public func update(generators: [StackCellGenerator]) {
        generators.forEach { generator in
            if let index = index(of: generator) {
                self.generators.remove(at: index)
                self.generators.insert(generator, at: index)
            } else {
                preconditionFailure("Can't find index in cellGenerators")
            }
        }
    }

    public func clearCellGenerators() {
        generators.removeAll()
    }

}

// MARK: - Private methods

private extension BaseStackManager {

    func index(of generator: StackCellGenerator) -> Int? {
        return generators.firstIndex(where: { $0 === generator })
    }

    func index(of view: UIView) -> Int? {
        return self.view.arrangedSubviews.firstIndex(where: { $0 == view })
    }

}
