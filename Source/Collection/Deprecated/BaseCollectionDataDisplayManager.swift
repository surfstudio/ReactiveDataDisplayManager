//
//  BaseCollectionDataDisplayManager.swift
//  ReactiveDataDisplayManager
//
//  Created by Anton Dryakhlykh on 25.11.2019.
//  Copyright © 2019 Александр Кравченков. All rights reserved.
//

import UIKit

/// Contains base implementation of DataDisplayManager and HeaderDataDisplayManager with UICollectionView.
/// Registers nibs.
/// Can fill collection with user data.
@available(*, deprecated, message: "Use BaseCollectionManager instead")
open class BaseCollectionDataDisplayManager: NSObject {

    // MARK: - Typealiases

    public typealias CollectionType = UICollectionView
    public typealias CellGeneratorType = CollectionCellGenerator
    public typealias HeaderGeneratorType = CollectionHeaderGenerator
    public typealias FooterGeneratorType = CollectionFooterGenerator

    // MARK: - Events

    /// Called if table scrolled
    public var scrollEvent = BaseEvent<UICollectionView>()
    public var changePageEvent = BaseEvent<UIScrollView>()

    // MARK: - Readonly properties

    public private(set) weak var view: UICollectionView!
    public private(set) var cellGenerators: [[CollectionCellGenerator]]
    public private(set) var sectionHeaderGenerators: [CollectionHeaderGenerator]
    public private(set) var sectionFooterGenerators: [CollectionFooterGenerator]

    // MARK: - Initialization and deinitialization

    required public init(collection: UICollectionView) {
        self.cellGenerators = [[CollectionCellGenerator]]()
        self.sectionHeaderGenerators = [CollectionHeaderGenerator]()
        self.sectionFooterGenerators = [CollectionFooterGenerator]()
        super.init()
        self.view = collection
        self.view?.delegate = self
        self.view?.dataSource = self
    }
}

// MARK: - DataDisplayManager

extension BaseCollectionDataDisplayManager: DataDisplayManager {
    public func addCellGenerator(_ generator: CollectionCellGenerator) {
        generator.registerCell(in: view)
        if self.cellGenerators.count != self.sectionHeaderGenerators.count || sectionHeaderGenerators.isEmpty {
            self.cellGenerators.append([CollectionCellGenerator]())
        }
        if sectionHeaderGenerators.count <= 0 {
            sectionHeaderGenerators.append(EmptyCollectionHeaderGenerator())
        }
        if sectionFooterGenerators.count <= 0 {
            sectionFooterGenerators.append(EmptyCollectionFooterGenerator())
        }
        // Add to last section
        let index = sectionHeaderGenerators.count - 1
        self.cellGenerators[index < 0 ? 0 : index].append(generator)
    }

    public func addCellGenerators(_ generators: [CollectionCellGenerator]) {
        for generator in generators {
            self.addCellGenerator(generator)
        }
    }

    public func addCellGenerators(_ generators: [CollectionCellGenerator], after: CollectionCellGenerator) {
        generators.forEach { $0.registerCell(in: view) }
        guard let (sectionIndex, generatorIndex) = findGenerator(after) else {
            return FatalErrorUtil.fatalError("Error adding cell generator. You tried to add generators after unexisted generator")
        }
        self.cellGenerators[sectionIndex].insert(contentsOf: generators, at: generatorIndex + 1)
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
        self.cellGenerators.removeAll()
    }

    public func forceRefill() {
        self.view?.reloadData()
    }
}

// MARK: - HeaderDataDisplayManager

extension BaseCollectionDataDisplayManager: HeaderDataDisplayManager {
    public func addSectionHeaderGenerator(_ generator: CollectionHeaderGenerator) {
        generator.registerHeader(in: view)
        self.sectionHeaderGenerators.append(generator)
    }

    public func addCellGenerator(_ generator: CollectionCellGenerator, toHeader header: CollectionHeaderGenerator) {
        addCellGenerators([generator], toHeader: header)
    }

    public func addCellGenerators(_ generators: [CollectionCellGenerator], toHeader header: CollectionHeaderGenerator) {
        generators.forEach { $0.registerCell(in: view) }

        if self.cellGenerators.count != self.sectionHeaderGenerators.count || sectionHeaderGenerators.isEmpty {
            self.cellGenerators.append([CollectionCellGenerator]())
        }

        if let index = self.sectionHeaderGenerators.firstIndex(where: { $0 === header }) {
            self.cellGenerators[index].append(contentsOf: generators)
        }
    }

    public func removeAllGenerators(from header: CollectionHeaderGenerator) {
        guard
           let index = self.sectionHeaderGenerators.firstIndex(where: { $0 === header }),
           self.cellGenerators.count > index
        else {
            return
        }

        self.cellGenerators[index].removeAll()
    }

    public func clearHeaderGenerators() {
        self.sectionHeaderGenerators.removeAll()
    }
}

// MARK: - FooterDataDisplayManager

extension BaseCollectionDataDisplayManager: FooterDataDisplayManager {
    public func addSectionFooterGenerator(_ generator: CollectionFooterGenerator) {
        generator.registerFooter(in: view)
        self.sectionFooterGenerators.append(generator)
    }

    public func addCellGenerator(_ generator: CollectionCellGenerator, toFooter footer: CollectionFooterGenerator) {
        addCellGenerators([generator], toFooter: footer)
    }

    public func addCellGenerators(_ generators: [CollectionCellGenerator], toFooter footer: CollectionFooterGenerator) {
        generators.forEach { $0.registerCell(in: view) }

        if self.cellGenerators.count != self.sectionFooterGenerators.count || self.sectionFooterGenerators.isEmpty {
            self.cellGenerators.append([CollectionCellGenerator]())
        }

        if let index = self.sectionFooterGenerators.firstIndex(where: { $0 === footer }) {
            self.cellGenerators[index].append(contentsOf: generators)
        }
    }

    public func removeAllGenerators(from footer: CollectionFooterGenerator) {
        guard
            let index = self.sectionFooterGenerators.firstIndex(where: { $0 === footer }),
            self.cellGenerators.count > index
        else {
            return
        }

        self.cellGenerators[index].removeAll()
    }

    public func clearFooterGenerators() {
        self.sectionFooterGenerators.removeAll()
    }

}

// MARK: - Private Methods

private extension BaseCollectionDataDisplayManager {
    func findGenerator(_ generator: CollectionCellGenerator) -> (sectionIndex: Int, generatorIndex: Int)? {
        for (sectionIndex, section) in cellGenerators.enumerated() {
            if let generatorIndex = section.firstIndex(where: { $0 === generator }) {
                return (sectionIndex, generatorIndex)
            }
        }
        return nil
    }
}

// MARK: - UICollectionViewDataSource

extension BaseCollectionDataDisplayManager: UICollectionViewDataSource {
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionHeaderGenerators.count
    }

    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if cellGenerators.indices.contains(section) {
            return cellGenerators[section].count
        } else {
            return 0
        }
    }

    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return cellGenerators[indexPath.section][indexPath.row].generate(collectionView: collectionView, for: indexPath)
    }

    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return self.sectionHeaderGenerators[indexPath.section].generate(collectionView: collectionView, for: indexPath)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension BaseCollectionDataDisplayManager: UICollectionViewDelegateFlowLayout {
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return self.sectionHeaderGenerators[section].size(collectionView, forSection: section)
    }
}

// MARK: - UICollectionViewDelegate

extension BaseCollectionDataDisplayManager: UICollectionViewDelegate {
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.scrollEvent.invoke(with: view)
    }

    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectable = self.cellGenerators[indexPath.section][indexPath.row] as? SelectableItem
        else {
            return
        }

        selectable.didSelectEvent.invoke(with: ())

        if selectable.isNeedDeselect {
            collectionView.deselectItem(at: indexPath, animated: true)
        }
    }

    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.changePageEvent.invoke(with: scrollView)
    }

    open func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard !decelerate else { return }
        self.changePageEvent.invoke(with: scrollView)
    }
}
