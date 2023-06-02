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

    // swiftlint:disable implicitly_unwrapped_optional
    public weak var view: UIStackView!
    public var cellGenerators: [StackCellGenerator] = []
    // swiftlint:enable implicitly_unwrapped_optional

    // MARK: - DataDisplayManager

    public func forceRefill() {
        view.arrangedSubviews.forEach { $0.removeFromSuperview() }

        cellGenerators.enumerated().forEach { offset, generator in
            guard let stackView = self.view else { return }
            let view = generator.generate(stackView: stackView, index: offset)
            stackView.addArrangedSubview(view)
        }
    }

    public func addCellGenerator(_ generator: StackCellGenerator) {
        cellGenerators.append(generator)
    }

    public func addCellGenerators(_ generators: [StackCellGenerator], after: StackCellGenerator) {
        if let index = index(of: after) {
            generators.enumerated().forEach { offset, generator in
                cellGenerators.insert(generator, at: index + offset + 1)
            }
        } else {
            cellGenerators.append(contentsOf: generators)
        }
    }

    public func addCellGenerator(_ generator: StackCellGenerator, after: StackCellGenerator) {
        if let index = index(of: after) {
            cellGenerators.insert(generator, at: index + 1)
        } else {
            cellGenerators.append(generator)
        }
    }

    public func addCellGenerators(_ generators: [StackCellGenerator]) {
        cellGenerators.append(contentsOf: generators)
    }

    public func update(generators: [StackCellGenerator]) {
        generators.forEach { generator in
            if let index = index(of: generator) {
                cellGenerators.remove(at: index)
                cellGenerators.insert(generator, at: index)
            } else {
                preconditionFailure("Can't find index in cellGenerators")
            }
        }
    }

    public func clearCellGenerators() {
        cellGenerators.removeAll()
    }

}

// MARK: - Private methods

private extension BaseStackManager {

    func index(of generator: StackCellGenerator) -> Int? {
        return cellGenerators.firstIndex(where: { $0 === generator })
    }

    func index(of view: UIView) -> Int? {
        return self.view.arrangedSubviews.firstIndex(where: { $0 == view })
    }

}
