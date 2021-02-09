//
//  TitleCollectionListGenerator.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Vadim Tikhonov on 09.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import ReactiveDataDisplayManager

class TitleCollectionListGenerator: SelectableItem {

    // MARK: - Events

    var didSelectEvent = BaseEvent<Void>()

    // MARK: - Stored properties

    var didSelected: Bool = false
    var isNeedDeselect: Bool = true
    fileprivate let model: String

    // MARK: - Initializers

    public init(model: String) {
        self.model = model
    }
}

// MARK: - TableCellGenerator

extension TitleCollectionListGenerator: CollectionCellGenerator {

    var identifier: String {
        return String(describing: TitleCollectionListCell.self)
    }

}

// MARK: - ViewBuilder

extension TitleCollectionListGenerator: ViewBuilder {

    func build(view: TitleCollectionListCell) {
        view.fill(with: model)
    }
}
