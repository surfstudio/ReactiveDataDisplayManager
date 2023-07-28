//
//  ImageCollectionCellGenerator.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 12.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import Foundation
import ReactiveDataDisplayManager

final class ImageCollectionCellGenerator: BaseCellGenerator<ImageCollectionViewCell>, PrefetcherableItem {

    // MARK: - PrefetcherableFlow

    var requestId: URL?

    // MARK: - Initialization

    init(model: ImageCollectionViewCell.ViewModel) {
        requestId = model.imageUrl
        super.init(with: model)
    }

}
