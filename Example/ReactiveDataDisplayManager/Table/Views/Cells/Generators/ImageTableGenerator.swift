//
//  ImageTableGenerator.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 29.01.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import Foundation
import ReactiveDataDisplayManager

final class ImageTableGenerator: BaseCellGenerator<ImageTableViewCell>, PrefetcherableItem {

    // MARK: - PrefetcherableFlow

    var requestId: URL?

    // MARK: - BaseCellGenerator

    init(with model: ImageTableViewCell.Model) {
        requestId = model.imageUrl
        super.init(with: model)
    }

}
