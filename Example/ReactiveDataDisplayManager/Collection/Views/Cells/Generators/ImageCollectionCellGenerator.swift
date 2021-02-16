//
//  ImageCollectionCellGenerator.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 12.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import ReactiveDataDisplayManager

final class ImageCollectionCellGenerator: PrefetcherableFlow {

    // MARK: - Properties

    var requestId: URL?

    // MARK: - Private Properties

    private let model: ImageCollectionViewCell.ViewModel

    // MARK: - Initialization

    init(model: ImageCollectionViewCell.ViewModel) {
        requestId = model.imageUrl
        self.model = model
    }

}

// MARK: - CollectionCellGenerator

extension ImageCollectionCellGenerator: CollectionCellGenerator {

    var identifier: String {
        return String(describing: ImageCollectionViewCell.self)
    }

}

// MARK: - ViewBuilder

extension ImageCollectionCellGenerator: ViewBuilder {

    func build(view: ImageCollectionViewCell) {
        view.configure(with: model)
    }

}
