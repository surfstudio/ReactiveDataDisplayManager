//
//  BaseCollectionManager.swift
//  ReactiveDataDisplayManager
//
//  Created by Vadim Tikhonov on 09.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

open class BaseCollectionManager: DataDisplayManager {

    public typealias CollectionType = UICollectionView
    public typealias CellGeneratorType = CollectionCellGenerator
    public typealias HeaderGeneratorType = CollectionHeaderGenerator

    // MARK: - Public properties

    public weak var view: UICollectionView?

    public var generators: [[CollectionCellGenerator]]
    public var sections: [CollectionHeaderGenerator]

    var delegate: BaseCollectionDelegate?
    var dataSource: BaseCollectionDataSource?

    public init() {
        generators = [[CollectionCellGenerator]]()
        sections = [CollectionHeaderGenerator]()
    }

    // MARK: - DataDisplayManager

    public func forceRefill() {
        self.view?.reloadData()
    }

    public func forceRefill(completion: @escaping (() -> Void)) {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            completion()
        }
        self.forceRefill()
        CATransaction.commit()
    }

    public func addCellGenerator(_ generator: CollectionCellGenerator) {
        guard let collection = self.view else { return }
        generator.registerCell(in: collection)

        if self.generators.count != self.sections.count || sections.isEmpty {
            self.generators.append([CollectionCellGenerator]())
        }

        if sections.count <= 0 {
            sections.append(EmptyCollectionHeaderGenerator())
        }

        // Add to last section
        let index = sections.count - 1
        self.generators[index < 0 ? 0 : index].append(generator)
    }

    public func addCellGenerators(_ generators: [CollectionCellGenerator]) {
        for generator in generators {
            self.addCellGenerator(generator)
        }
    }

    public func addCellGenerators(_ generators: [CollectionCellGenerator], after: CollectionCellGenerator) {
        guard let collection = self.view else { return }

        generators.forEach { $0.registerCell(in: collection) }

        guard let (sectionIndex, generatorIndex) = findGenerator(after) else {
            fatalError("Error adding cell generator. You tried to add generators after unexisted generator")
        }

        self.generators[sectionIndex].insert(contentsOf: generators, at: generatorIndex + 1)
    }

    public func addCellGenerator(_ generator: CollectionCellGenerator, after: CollectionCellGenerator) {
        addCellGenerators([generator], after: after)
    }

    public func update(generators: [CollectionCellGenerator]) {
        let indexes = generators.compactMap { [weak self] in self?.findGenerator($0) }
        let indexPaths = indexes.compactMap { IndexPath(row: $0.generatorIndex, section: $0.sectionIndex) }
        self.view?.reloadItems(at: indexPaths)
    }

    public func clearCellGenerators() {
        self.generators.removeAll()
    }

}

// MARK: - HeaderDataDisplayManager

extension BaseCollectionManager: HeaderDataDisplayManager {

    public func addSectionHeaderGenerator(_ generator: CollectionHeaderGenerator) {
        guard let collection = self.view else { return }
        generator.registerHeader(in: collection)
        self.sections.append(generator)
    }

    public func addCellGenerator(_ generator: CollectionCellGenerator, toHeader header: CollectionHeaderGenerator) {
        addCellGenerators([generator], toHeader: header)
    }

    public func addCellGenerators(_ generators: [CollectionCellGenerator], toHeader header: CollectionHeaderGenerator) {
        guard let collection = self.view else { return }
        generators.forEach { $0.registerCell(in: collection) }

        if self.generators.count != self.sections.count || sections.isEmpty {
            self.generators.append([CollectionCellGenerator]())
        }

        if let index = self.sections.index(where: { $0 === header }) {
            self.generators[index].append(contentsOf: generators)
        }
    }

    public func removeAllGenerators(from header: CollectionHeaderGenerator) {
        guard
           let index = self.sections.index(where: { $0 === header }),
           self.generators.count > index
       else {
           return
       }

        self.generators[index].removeAll()
    }

    public func clearHeaderGenerators() {
        self.sections.removeAll()
    }

}

// MARK: - Private Methods

private extension BaseCollectionManager {

    func findGenerator(_ generator: CollectionCellGenerator) -> (sectionIndex: Int, generatorIndex: Int)? {
        for (sectionIndex, section) in generators.enumerated() {
            if let generatorIndex = section.index(where: { $0 === generator }) {
                return (sectionIndex, generatorIndex)
            }
        }
        return nil
    }

}

// MARK: - UICollectionViewDelegateFlowLayout

//extension BaseCollectionManager: UICollectionViewDelegateFlowLayout {
//
//    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return self.sections[section].size(collectionView, forSection: section)
//    }
//
//}
