//
//  EmptyCollectionFooterGenarator.swift
//  ReactiveDataDisplayManager
//
//  Created by Dmitry Korolev on 05.04.2021.
//

import UIKit

public class EmptyCollectionFooterGenerator: CollectionFooterGenerator {

    public let uuid = UUID().uuidString
    public let elementKind = UICollectionView.elementKindSectionFooter

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
        DiffableItem(id: uuid, state: .init("RDDM.Diffable.EmptySection.footer"))
    }

}
