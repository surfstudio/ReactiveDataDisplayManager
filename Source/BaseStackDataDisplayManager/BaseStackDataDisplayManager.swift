//
//  BaseStackDataDisplayManager.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Dryakhlykh on 14.10.2019.
//  Copyright © 2019 Александр Кравченков. All rights reserved.
//

import UIKit

/// Contains base implementation of DataDisplayManager with UIStackView.
/// Can fill stack with user data.
@available(*, deprecated, message: "Use BaseStackManager instead")
open class BaseStackDataDisplayManager: NSObject, DataDisplayManager {

    // MARK: - Typealiases

    public typealias CollectionType = UIStackView
    public typealias CellGeneratorType = StackCellGenerator

    // MARK: - Properties

    public private(set) weak var view: UIStackView!
    public private(set) var cellGenerators: [StackCellGenerator]

    // MARK: - DataDisplayManager

    public required init(collection: UIStackView) {
        self.view = collection
        self.cellGenerators = []
    }

    public func forceRefill() {
        self.view.arrangedSubviews.forEach { $0.removeFromSuperview() }

        self.cellGenerators.enumerated().forEach { [weak self] offset, generator in
            guard let stackView = self?.view else { return }
            let view = generator.generate(stackView: stackView, index: offset)
            stackView.addArrangedSubview(view)
        }
    }

    public func addCellGenerator(_ generator: StackCellGenerator) {
        self.cellGenerators.append(generator)
    }

    public func addCellGenerators(_ generators: [StackCellGenerator], after: StackCellGenerator) {
        if let index = self.index(of: after) {
            generators.enumerated().forEach { offset, generator in
                self.cellGenerators.insert(generator, at: index + offset + 1)
            }
        } else {
            self.cellGenerators.append(contentsOf: generators)
        }
    }

    public func addCellGenerator(_ generator: StackCellGenerator, after: StackCellGenerator) {
        if let index = self.index(of: after) {
            self.cellGenerators.insert(generator, at: index + 1)
        } else {
            self.cellGenerators.append(generator)
        }
    }

    public func addCellGenerators(_ generators: [StackCellGenerator]) {
        self.cellGenerators.append(contentsOf: generators)
    }

    public func update(generators: [StackCellGenerator]) {
        generators.forEach { generator in
            if let index = self.index(of: generator) {
                self.cellGenerators.remove(at: index)
                self.cellGenerators.insert(generator, at: index)
            } else {
                preconditionFailure("Can't find index in cellGenerators")
            }
        }
    }

    public func clearCellGenerators() {
        self.cellGenerators.removeAll()
    }

    // MARK: - Private methods

    private func index(of generator: StackCellGenerator) -> Int? {
        return self.cellGenerators.firstIndex(where: { $0 === generator })
    }

    private func index(of view: UIView) -> Int? {
        return self.view?.arrangedSubviews.firstIndex(where: { $0 == view })
    }
}
