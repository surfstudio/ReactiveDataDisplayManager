//
//  ImageTableGenerator.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 29.01.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import ReactiveDataDisplayManager

final class ImageTableGenerator: PrefetcherableFlow {

    // MARK: - Properties

    var requestId: URL?

    // MARK: - Private Properties

    private let model: ImageTableViewCell.ViewModel

    // MARK: - Initializers

    public init(model: ImageTableViewCell.ViewModel) {
        self.model = model
        requestId = model.imageUrl
    }

}

// MARK: - TableCellGenerator

extension ImageTableGenerator: TableCellGenerator {

    var identifier: String {
        return String(describing: ImageTableViewCell.self)
    }

}

// MARK: - ViewBuilder

extension ImageTableGenerator: ViewBuilder {

    func build(view: ImageTableViewCell) {
        view.configure(with: model)
    }

}
