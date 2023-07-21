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
