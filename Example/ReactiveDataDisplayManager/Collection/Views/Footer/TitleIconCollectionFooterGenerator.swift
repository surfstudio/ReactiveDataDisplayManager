//
//  TitleCollectionFooterGenerator.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Dmitry Korolev on 05.04.2021.
//

import UIKit
import ReactiveDataDisplayManager

final class TitleIconCollectionFooterGenerator {

    // MARK: - Private Properties

    private let title: String

    // MARK: - Initialization

    init(title: String) {
        self.title = title
    }
}

// MARK: - CollectionFooterGenerator

extension TitleIconCollectionFooterGenerator: CollectionFooterGenerator {

    var identifier: UICollectionReusableView.Type {
        return TitleIconCollectionFooterView.self
    }

    func size(_ collectionView: UICollectionView, forSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 40.0)
    }

}

// MARK: - ViewBuilder

extension TitleIconCollectionFooterGenerator: ViewBuilder {

    func build(view: TitleIconCollectionFooterView) {
        view.fill(title: title)
    }

}
