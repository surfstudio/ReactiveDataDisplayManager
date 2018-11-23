//
//  BaseCollectionDataDisplayManager.swift
//  ReactiveDataDisplayManager
//
//  Created by Ivan Smetanin on 28/01/2018.
//

import Foundation
import UIKit

/// Contains base implementation of TableDataManager and TableDisplayManager.
/// Can register nib if needed, determinate EstimatedRowHeight.
/// Can fill table with user data.
open class BaseCollectionDataDisplayManager: NSObject {

    // MARK: - Events

    /// Called if content scrolled
    public var scrollEvent = BaseEvent<UICollectionView>()
    public var scrollViewWillEndDraggingEvent: BaseEvent<CGPoint> = BaseEvent<CGPoint>()

    // MARK: - Fileprivate properties

    fileprivate(set) var cellGenerators: [CollectionCellGenerator]
    fileprivate var headerGenerators: [CollectionHeaderGenerator]
    fileprivate weak var collectionView: UICollectionView?

    // MARK: - Initialization

    public required init(collection: UICollectionView) {
        self.cellGenerators = [CollectionCellGenerator]()
        self.headerGenerators = [CollectionHeaderGenerator]()
        self.collectionView = collection
        super.init()
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
    }

}

// MARK: - DataDisplayManager

extension BaseCollectionDataDisplayManager: DataDisplayManager {

    public typealias CollectionType = UICollectionView
    public typealias CellGeneratorType = CollectionCellGenerator
    public typealias HeaderGeneratorType = CollectionHeaderGenerator

    public func forceRefill() {
        self.collectionView?.reloadData()
    }

    public func addCellGenerator(_ generator: CollectionCellGenerator) {
        guard let collection = self.collectionView else { return }
        generator.registerCell(in: collection)
        self.cellGenerators.append(generator)
    }

    public func addCellGenerators(_ generators: [CollectionCellGenerator]) {
        guard let collection = self.collectionView else { return }
        generators.forEach { $0.registerCell(in: collection) }
        self.cellGenerators.append(contentsOf: generators)
    }

    public func addSectionHeaderGenerator(_ generator: CollectionHeaderGenerator) {
        self.headerGenerators.append(generator)
    }

    public func addCellGenerator(_ generator: CollectionCellGenerator, after: CollectionCellGenerator) {
        guard let collection = collectionView else { return }
        generator.registerCell(in: collection)

        guard let index = self.cellGenerators.index(where: { $0 === after }) else {
            fatalError("Fatal Error in \(#function). You tried to add generators after unexisted generator")
        }
        self.cellGenerators.insert(generator, at: index + 1)
    }

    public func addCellGenerators(_ generators: [CollectionCellGenerator], after: CollectionCellGenerator) {
        guard let collection = self.collectionView else { return }
        generators.forEach { $0.registerCell(in: collection) }

        guard let index = self.cellGenerators.index(where: { $0 === after }) else {
            fatalError("Fatal Error in \(#function). You tried to add generators after unexisted generator")
        }
        self.cellGenerators.insert(contentsOf: generators, at: index + 1)
    }

    public func update(generators: [CollectionCellGenerator]) {
        let indexes = generators.compactMap { [weak self] generator in
            self?.cellGenerators.index(where: { $0 === generator })
        }
        let indexPaths = indexes.compactMap { IndexPath(row: $0, section: 0) }
        self.collectionView?.reloadItems(at: indexPaths)
    }

    public func clearCellGenerators() {
        self.cellGenerators.removeAll()
    }

    public func clearHeaderGenerators() {
        self.headerGenerators.removeAll()
    }

}

// MARK: - UICollectionViewDelegate

extension BaseCollectionDataDisplayManager: UICollectionViewDelegate {

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let collectionView = self.collectionView else { return }
        self.scrollEvent.invoke(with: collectionView)
    }

    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        self.scrollViewWillEndDraggingEvent.invoke(with: velocity)
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectable = self.cellGenerators[indexPath.row] as? SelectableItem else { return }
        selectable.didSelectEvent.invoke(with: ())
        if selectable.isNeedDeselect {
            collectionView.deselectItem(at: indexPath, animated: true)
        }
    }

}

// MARK: - UITableViewDataSource

extension BaseCollectionDataDisplayManager: UICollectionViewDataSource {

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.headerGenerators.isEmpty ? 1 : self.headerGenerators.count
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cellGenerators.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return self.cellGenerators[indexPath.row].generate(collectionView: collectionView, for: indexPath)
    }

    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return self.headerGenerators.first { $0.identifier == kind }?.generate() ?? UICollectionReusableView()
    }

}
