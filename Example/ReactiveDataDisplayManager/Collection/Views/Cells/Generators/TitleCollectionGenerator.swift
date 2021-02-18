//
//  TitleCollectionGenerator.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Ivan Smetanin on 28/01/2018.
//  Copyright © 2018 Alexander Kravchenkov. All rights reserved.
//

import ReactiveDataDisplayManager

final class TitleCollectionGenerator: IndexTitleDisplayble {

    // MARK: - Properties

    var title: String
    var needIndexTitle: Bool

    // MARK: - Private Properties

    private let model: String

    // MARK: - Initialization

    public init(model: String, needIndexTitle: Bool = false) {
        self.model = model
        self.title = model
        self.needIndexTitle = needIndexTitle
    }

}

// MARK: - CollectionCellGenerator

extension TitleCollectionGenerator: CollectionCellGenerator {

    var identifier: String {
        return String(describing: TitleCollectionViewCell.self)
    }

}

// MARK: - ViewBuilder

extension TitleCollectionGenerator: ViewBuilder {

    func build(view: TitleCollectionViewCell) {
        view.configure(with: model)
    }

}
