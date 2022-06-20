//
//  MockCollectionCellGenerator.swift
//  ReactiveDataDisplayManager
//
//  Created by porohov on 20.06.2022.
//

import UIKit
@testable import ReactiveDataDisplayManager

final class MockCollectionCellGenerator: CollectionCellGenerator {

    var identifier: String {
        return String(describing: UICollectionViewCell.self)
    }

    func generate(collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }

    func registerCell(in collectionView: UICollectionView) {
        DispatchQueue.main.async {
            collectionView.registerNib(self.identifier)
        }
    }

}
