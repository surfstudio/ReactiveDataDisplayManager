//
//  FoldableCollectionCellGenerator.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Vadim Tikhonov on 11.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import ReactiveDataDisplayManager

final class FoldableCollectionCellGenerator: CollectionFoldableItem {

    // MARK: - FoldableItem

    var didFoldEvent = BaseEvent<Bool>()
    var isExpanded = false
    var childGenerators: [CollectionCellGenerator] = []

    // MARK: - Private Properties

    private let model: FoldableCollectionViewCell.ViewModel

    // MARK: - Initialization

    public init(with model: FoldableCollectionViewCell.ViewModel) {
        self.model = model
        self.isExpanded = model.expanded
    }

}

// MARK: - TableCellGenerator

extension FoldableCollectionCellGenerator: CollectionCellGenerator {

    var identifier: String {
        return String(describing: FoldableCollectionViewCell.self)
    }

}

// MARK: - ViewBuilder

extension FoldableCollectionCellGenerator: ViewBuilder {

    func build(view: FoldableCollectionViewCell) {
        view.configure(with: model)

        didFoldEvent.addListner { isExpanded in
            view.configure(expanded: isExpanded)
        }
    }

}
