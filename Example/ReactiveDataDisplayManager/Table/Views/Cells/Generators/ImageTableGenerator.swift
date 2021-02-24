//
//  ImageTableGenerator.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 29.01.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import ReactiveDataDisplayManager

final class ImageTableGenerator: BaseCellGenerator<ImageTableViewCell>, PrefetcherableFlow {

    // MARK: - PrefetcherableFlow

    var requestId: URL?

    // MARK: - BaseCellGenerator

    override func configure(cell: ImageTableViewCell, with model: ImageTableViewCell.Model) {
        super.configure(cell: cell, with: model)
        requestId = model.imageUrl
    }

}
