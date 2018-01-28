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
public class BaseCollectionDataDisplayManager: NSObject {

    // MARK: - Events

    /// Called if table scrolled
    public var scrollEvent = BaseEvent<UICollectionView>()
    public var scrollViewWillEndDraggingEvent: BaseEvent<CGPoint> = BaseEvent<CGPoint>()

    // MARK: - Fileprivate properties

    fileprivate(set) var cellGenerators: [CollectionCellGenerator]
    fileprivate var headerGenerators: [CollectionHeaderGenerator]
    fileprivate weak var collectionView: UICollectionView?

    // MARK: - Initialization and deinitialization

    public override init() {
        self.cellGenerators = [CollectionCellGenerator]()
        self.headerGenerators = [CollectionHeaderGenerator]()
        super.init()
    }

}

// MARK: - DataDisplayManager

extension BaseCollectionDataDisplayManager: DataDisplayManager {

    public typealias CollectionType = UICollectionView
    public typealias CellGeneratorType = CollectionCellGenerator
    public typealias HeaderGeneratorType = CollectionHeaderGenerator

    public func set(collection: UICollectionView) {
        self.collectionView = collection
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
    }

    public func addCellGenerator(_ generator: CollectionCellGenerator) {
        self.collectionView?.registerNib(generator.identifier)
        self.cellGenerators.append(generator)
    }

    public func addCellGenerators(_ generators: [CollectionCellGenerator]) {
        generators.forEach { self.collectionView?.registerNib($0.identifier) }
        self.cellGenerators.append(contentsOf: generators)
    }

    public func addSectionHeaderGenerator(_ generator: CollectionHeaderGenerator) {
        self.headerGenerators.append(generator)
    }

    public func clearCellGenerators() {
        self.cellGenerators.removeAll()
    }

    public func clearHeaderGenerators() {
        self.headerGenerators.removeAll()
    }

    public func didRefill() {
        self.collectionView?.reloadData()
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
        return headerGenerators.isEmpty ? 1 : headerGenerators.count
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cellGenerators.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return self.cellGenerators[indexPath.row].generate(collectionView: collectionView, for: indexPath)
    }

}
