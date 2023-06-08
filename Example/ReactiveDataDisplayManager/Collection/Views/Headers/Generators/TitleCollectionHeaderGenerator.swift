//
//  TitleCollectionHeaderGenerator.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Dryakhlykh on 25.11.2019.
//  Copyright © 2019 Alexander Kravchenkov. All rights reserved.
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
        return TitleCollectionReusableView.self
    }

    func size(_ collectionView: UICollectionView, forSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 56.0)
    }

}

// MARK: - ViewBuilder

extension TitleCollectionHeaderGenerator: ViewBuilder {

    func build(view: TitleCollectionReusableView) {
        view.fill(title: title)
    }

}
