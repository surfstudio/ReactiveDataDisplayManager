//
//  TitleCollectionHeaderGenerator.swift
//  ReactiveDataDisplayManagerExample_iOS
//
//  Created by Никита Коробейников on 09.06.2021.
//

import UIKit
import ReactiveDataDisplayManager

final class TitleCollectionHeaderGenerator {

    // MARK: - Private Properties

    private let title: String

    // MARK: - Initialization

    init(title: String) {
        self.title = title
    }
}

// MARK: - CollectionHeaderGenerator

extension TitleCollectionHeaderGenerator: CollectionHeaderGenerator {

    var identifier: UICollectionReusableView.Type {
        TitleCollectionReusableView.self
    }

    func size(_ collectionView: UICollectionView, forSection section: Int) -> CGSize {
        let width = collectionView.bounds.width
        let height = TitleCollectionReusableView.getHeight(forWidth: width, with: title)
        return CGSize(width: width, height: height)
    }

}

// MARK: - ViewBuilder

extension TitleCollectionHeaderGenerator: ViewBuilder {

    func build(view: TitleCollectionReusableView) {
        view.configure(with: title)
    }

}
