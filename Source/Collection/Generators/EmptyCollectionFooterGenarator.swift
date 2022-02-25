//
//  EmptyCollectionFooterGenarator.swift
//  ReactiveDataDisplayManager
//
//  Created by Dmitry Korolev on 05.04.2021.
//

import UIKit

public class EmptyCollectionFooterGenerator: CollectionFooterGenerator, IdOwner {

    public let id: AnyHashable
    public let elementKind = UICollectionView.elementKindSectionFooter

    public init() {
        self.id = UUID().uuidString
    }

    public init(uniqueId: AnyHashable) {
        self.id = uniqueId
    }

    public func size(_ collectionView: UICollectionView, forSection section: Int) -> CGSize {
        return .zero
    }

    public func generate(collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: elementKind,
                                                                     withReuseIdentifier: self.identifier.nameOfClass,
                                                                     for: indexPath)
        return header
    }

    public func registerFooter(in collectionView: UICollectionView) {
        collectionView.register(identifier,
                                forSupplementaryViewOfKind: elementKind,
                                withReuseIdentifier: identifier.nameOfClass)
    }

    public var identifier: UICollectionReusableView.Type {
        return UICollectionReusableView.self
    }

}

// MARK: - DiffableItemSource

extension EmptyCollectionFooterGenerator: DiffableItemSource {

    public var diffableItem: DiffableItem {
        DiffableItem(id: id, state: .init("RDDM.Diffable.EmptySection"))
    }

}
