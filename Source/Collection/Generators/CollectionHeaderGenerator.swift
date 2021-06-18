//
//  CollectionHeaderGenerator.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 18.06.2021.
//

import UIKit

/// Protocol that incapsulated type of Header
public protocol CollectionHeaderGenerator: AnyObject {

    var identifier: UICollectionReusableView.Type { get }

    func generate(collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionReusableView

    func registerHeader(in collectionView: UICollectionView)

    func size(_ collectionView: UICollectionView, forSection section: Int) -> CGSize

    /// Method for SPM support
    ///
    /// If you use SPM return Bundle.module
    static func bundle() -> Bundle?
}

// MARK: - Defaults

public extension CollectionHeaderGenerator {

    static func bundle() -> Bundle? {
        return nil
    }

}

// MARK: - ViewBuilder

public extension CollectionHeaderGenerator where Self: ViewBuilder {
    func generate(collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                           withReuseIdentifier: self.identifier.nameOfClass,
                                                                           for: indexPath) as? Self.ViewType else {
            return UICollectionReusableView()
        }

        self.build(view: header)

        return header as? UICollectionReusableView ?? UICollectionReusableView()
    }

    func registerHeader(in collectionView: UICollectionView) {
        collectionView.registerNib(self.identifier,
                                   kind: UICollectionView.elementKindSectionHeader,
                                   bundle: Self.bundle())
    }
}
