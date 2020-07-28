//
//  TitleCollectionGenerator.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Ivan Smetanin on 28/01/2018.
//  Copyright © 2018 Alexander Kravchenkov. All rights reserved.
//

import ReactiveDataDisplayManager

class TitleCollectionGenerator: SelectableItem {

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
