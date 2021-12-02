//
//  BaseCollectionManager.swift
//  ReactiveDataDisplayManager
//
//  Created by Vadim Tikhonov on 09.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

open class BaseCollectionManager: CollectionGeneratorsProvider, DataDisplayManager {

    // MARK: - Typealias

    public typealias CollectionType = UICollectionView
    public typealias CellGeneratorType = CollectionCellGenerator
    public typealias HeaderGeneratorType = CollectionHeaderGenerator
    public typealias FooterGeneratorType = CollectionFooterGenerator

    public typealias CollectionAnimator = Animator<CollectionType>

    // MARK: - Public properties

    // swiftlint:disable implicitly_unwrapped_optional
    public weak var view: UICollectionView!
    // swiftlint:enable implicitly_unwrapped_optional

    var delegate: CollectionDelegate?
    var dataSource: CollectionDataSource?

    // MARK: - DataDisplayManager

    public func forceRefill() {
        dataSource?.modifier?.reload()
    }
    
    public func addCellGenerator(_ generator: CollectionCellGenerator) {
        addCellGenerators([generator])
    }

    public func addCellGenerators(_ generators: [CollectionCellGenerator]) {
        generators.forEach { $0.registerCell(in: view) }
        addCollectionGenerators(with: generators, choice: .lastSection)
    }

    public func addCellGenerators(_ generators: [CollectionCellGenerator], after: CollectionCellGenerator) {
        generators.forEach { $0.registerCell(in: view) }

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
        dataSource?.modifier?.reloadRows(at: indexPaths, with: .animated)
    }

    public func clearCellGenerators() {
        self.generators.removeAll()
    }

}

// MARK: - HeaderDataDisplayManager

extension BaseCollectionManager: HeaderDataDisplayManager {

    public func addSectionHeaderGenerator(_ generator: CollectionHeaderGenerator) {
        generator.registerHeader(in: view)
        self.headers.append(generator)
        checkEmptySection(for: headers)
    }

    public func addCellGenerator(_ generator: CollectionCellGenerator, toHeader header: CollectionHeaderGenerator) {
        addCellGenerators([generator], toHeader: header)
    }

    public func addCellGenerators(_ generators: [CollectionCellGenerator], toHeader header: CollectionHeaderGenerator) {
        generators.forEach { $0.registerCell(in: view) }

        guard let index = getIndex(for: header, in: headers) else { return }
        addCollectionGenerators(with: generators, choice: .byIndex(index))
    }

    public func removeAllGenerators(from header: CollectionHeaderGenerator) {
        guard
            let index = self.headers.firstIndex(where: { $0 === header }),
            self.generators.count > index
        else {
            return
        }

        self.generators[index].removeAll()
    }

    public func clearHeaderGenerators() {
        self.headers.removeAll()
    }

}

// MARK: - FooterDataDisplayManager

extension BaseCollectionManager: FooterDataDisplayManager {

    public func addSectionFooterGenerator(_ generator: CollectionFooterGenerator) {
        generator.registerFooter(in: view)
        self.footers.append(generator)
        checkEmptySection(for: footers)
    }

    public func addCellGenerator(_ generator: CollectionCellGenerator, toFooter footer: CollectionFooterGenerator) {
        addCellGenerators([generator], toFooter: footer)
    }

    public func addCellGenerators(_ generators: [CollectionCellGenerator], toFooter footer: CollectionFooterGenerator) {
        generators.forEach { $0.registerCell(in: view) }

        guard let index = getIndex(for: footer, in: footers) else { return }
        addCollectionGenerators(with: generators, choice: .byIndex(index))
    }

    public func removeAllGenerators(from footer: CollectionFooterGenerator) {
        guard
            let index = self.footers.firstIndex(where: { $0 === footer }),
            self.generators.count > index
        else {
            return
        }

        self.generators[index].removeAll()
    }

    public func clearFooterGenerators() {
        self.footers.removeAll()
    }

}

// MARK: - Helper

extension BaseCollectionManager {

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

    /// Removes generator from data display manager. Generators compares by references.
    ///
    /// - Parameters:
    ///   - generator: Generator to delete.
    ///   - needScrollAt: If not nil than performs scroll before removing generator.
    /// A constant that identifies a relative position in the collection view (top, middle, bottom)
    /// for item when scrolling concludes. See UICollectionViewScrollPosition for descriptions of valid constants.
    ///   - needRemoveEmptySection: Pass **true** if you need to remove section if it'll be empty after deleting.
    open func remove(_ generator: CollectionCellGenerator,
                     needScrollAt scrollPosition: UICollectionView.ScrollPosition?,
                     needRemoveEmptySection: Bool) {
        guard let index = findGenerator(generator) else { return }
        self.removeGenerator(with: index,
                             needScrollAt: scrollPosition,
                             needRemoveEmptySection: needRemoveEmptySection)
    }

}

// MARK: - Private Methods

private extension BaseCollectionManager {

    func insert(elements: [(generator: CollectionCellGenerator, sectionIndex: Int, generatorIndex: Int)]) {

        elements.forEach { [weak self] element in
            element.generator.registerCell(in: view)
            self?.generators[element.sectionIndex].insert(element.generator, at: element.generatorIndex)
        }

        let indexPaths = elements.map {
            IndexPath(row: $0.generatorIndex, section: $0.sectionIndex)
        }

        dataSource?.modifier?.insertRows(at: indexPaths, with: .animated)
    }

    func findGenerator(_ generator: CollectionCellGenerator) -> (sectionIndex: Int, generatorIndex: Int)? {
        for (sectionIndex, section) in generators.enumerated() {
            if let generatorIndex = section.firstIndex(where: { $0 === generator }) {
                return (sectionIndex, generatorIndex)
            }
        }
        return nil
    }

    // TODO: May be we should remove needScrollAt and move this responsibility to user
    func removeGenerator(with index: (sectionIndex: Int, generatorIndex: Int),
                         needScrollAt scrollPosition: UICollectionView.ScrollPosition? = nil,
                         needRemoveEmptySection: Bool = false) {

        generators[index.sectionIndex].remove(at: index.generatorIndex)
        let indexPath = IndexPath(row: index.generatorIndex, section: index.sectionIndex)

        // remove empty section if needed
        var sectionIndexPath: IndexSet?
        let sectionIsEmpty = generators[index.sectionIndex].isEmpty
        if needRemoveEmptySection && sectionIsEmpty {
            generators.remove(at: index.sectionIndex)
            headers.remove(at: index.sectionIndex)
            sectionIndexPath = IndexSet(integer: index.sectionIndex)
        }

        // apply changes in table
        dataSource?.modifier?.removeRows(at: [indexPath], and: sectionIndexPath, with: .animated)

        // scroll if needed
        if let scrollPosition = scrollPosition {
            view.scrollToItem(at: indexPath, at: scrollPosition, animated: true)
        }
    }

}
