//
//  TitleCollectionGenerator.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Ivan Smetanin on 28/01/2018.
//  Copyright © 2018 Alexander Kravchenkov. All rights reserved.
//

import ReactiveDataDisplayManager

final class TitleCollectionGenerator: SelectableItem {

    // MARK: - Properties

    var didSelectEvent = BaseEvent<Void>()
    var didSelected: Bool = false
    var isNeedDeselect: Bool = true

    // MARK: - Private Properties

    private let model: String

    // MARK: - Initialization

    public init(model: String) {
        self.model = model
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
        view.fill(with: model)
    }

}
