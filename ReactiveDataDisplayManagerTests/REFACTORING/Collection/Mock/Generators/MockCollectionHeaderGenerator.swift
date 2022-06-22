//
//  MockCollectionHeaderGenerator.swift
//  ReactiveDataDisplayManager
//
//  Created by porohov on 20.06.2022.
//
import XCTest
import UIKit
@testable import ReactiveDataDisplayManager

final class MockCollectionHeaderGenerator: CollectionHeaderGenerator {

    var expect: XCTestExpectation?

    init(expect: XCTestExpectation? = nil) {
        self.expect = expect
    }

    var identifier: UICollectionReusableView.Type {
        return UICollectionReusableView.self
    }

    func generate(collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionReusableView {
        return UICollectionReusableView()
    }

    func registerHeader(in collectionView: UICollectionView) {
        DispatchQueue.main.async {
            collectionView.register(self.identifier, forCellWithReuseIdentifier: UICollectionView.elementKindSectionHeader)
            self.expect?.fulfill()
        }
    }

    func size(_ collectionView: UICollectionView, forSection section: Int) -> CGSize {
        return .zero
    }

}
