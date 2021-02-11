//
//  ManualCollectionManager.swift
//  ReactiveDataDisplayManager
//
//  Created by Vadim Tikhonov on 11.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

////Base implementation of a CollectionStateManager. Handles all operations with generators and sections.
public class ManualCollectionManager: BaseCollectionManager {

    /// Inserts new generators after provided generator.
    ///
    /// - Parameters:
    ///   - after: Generator after which new generator will be added. Must be in the DDM.
    ///   - new: Generators which you want to insert after current generator.
    open func insert(after generator: CollectionCellGenerator,
                     new newGenerators: [CollectionCellGenerator]) {
        guard let index = self.findGenerator(generator) else { return }

        let elements = newGenerators.enumerated().map { item in
            (item.element, index.sectionIndex, index.generatorIndex + item.offset + 1)
        }
        self.insert(elements: elements)
    }

}

// MARK: - Private Methods

private extension ManualCollectionManager {

    func insert(elements: [(generator: CollectionCellGenerator, sectionIndex: Int, generatorIndex: Int)]) {
        guard let collection = self.view else {
            return
        }

        elements.forEach { [weak self] element in
            element.generator.registerCell(in: collection)
            self?.generators[element.sectionIndex].insert(element.generator, at: element.generatorIndex)
        }

        let indexPaths = elements.map {
            IndexPath(row: $0.generatorIndex, section: $0.sectionIndex)
        }

        collection.insertItems(at: indexPaths)
    }

}
