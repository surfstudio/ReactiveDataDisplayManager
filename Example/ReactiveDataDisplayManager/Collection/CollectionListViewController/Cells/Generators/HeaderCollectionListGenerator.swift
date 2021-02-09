//
//  HeaderCollectionListGenerator.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Vadim Tikhonov on 09.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import ReactiveDataDisplayManager

final class HeaderCollectionListGenerator {

    // MARK: - Constants

    private let title: String

    // MARK: - Initialization and deinitialization

    init(title: String) {
        self.title = title
    }
}

// MARK: - CollectionHeaderGenerator

extension HeaderCollectionListGenerator: CollectionHeaderGenerator {
    var identifier: UICollectionReusableView.Type {
        return HeaderCollectionListView.self
    }

    func size(_ collectionView: UICollectionView, forSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 44.0)
    }
}

// MARK: - ViewBuilder

extension HeaderCollectionListGenerator: ViewBuilder {
    func build(view: HeaderCollectionListView) {
        view.fill(title: title)
    }
}

