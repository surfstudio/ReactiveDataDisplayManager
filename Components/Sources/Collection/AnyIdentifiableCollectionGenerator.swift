//
//  AnyIdentifiableCollectionGenerator.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 24.05.2023.
//

import UIKit
import ReactiveDataDisplayManager

/// Wrapper class to erase type of original `CollectionCellGenerator`.
/// Used to merge different types of generators into one array.
public final class AnyIdentifiableCollectionGenerator: CollectionCellGenerator, DiffableItemSource {

    public typealias IdentifiableGenerator = CollectionCellGenerator & DiffableItemSource

    private let wrappedValue: IdentifiableGenerator

    // MARK: - RegisterableItem

    public var descriptor: String {
        wrappedValue.descriptor
    }

    // MARK: - DiffableItemSource

    public var identifier: String {
        wrappedValue.identifier
    }

    public var diffableItem: DiffableItem {
        wrappedValue.diffableItem
    }

    // MARK: - Initialisations

    public init(generator: IdentifiableGenerator) {
        self.wrappedValue = generator
    }

    public init?(identifiable: DiffableItemSource) {
        guard let generator = identifiable as? IdentifiableGenerator else {
            return nil
        }
        self.wrappedValue = generator
    }

    // MARK: - Generator

    public func generate(collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionViewCell {
        wrappedValue.generate(collectionView: collectionView, for: indexPath)
    }

    public func registerCell(in collectionView: UICollectionView) {
        wrappedValue.registerCell(in: collectionView)
    }

}
