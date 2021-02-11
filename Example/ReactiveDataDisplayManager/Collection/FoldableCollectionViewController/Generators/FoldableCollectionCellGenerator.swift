//
//  FoldableCollectionCellGenerator.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Vadim Tikhonov on 11.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import ReactiveDataDisplayManager

public protocol CollectionFoldableItem: class {
    var didFoldEvent: BaseEvent<Bool> { get }
    var isExpanded: Bool { get set }
    var childGenerators: [CollectionCellGenerator] { get set }
}

final class FoldableCollectionCellGenerator: CollectionFoldableItem {

    // MARK: - FoldableItem

    var didFoldEvent = BaseEvent<Bool>()
    var isExpanded = false
    var childGenerators: [CollectionCellGenerator] = []

}

// MARK: - TableCellGenerator

extension FoldableCollectionCellGenerator: CollectionCellGenerator {

    var identifier: String {
        return String(describing: ImageCollectionViewCell.self)
    }

}

// MARK: - ViewBuilder

extension FoldableCollectionCellGenerator: ViewBuilder {

    func build(view: ImageCollectionViewCell) {
//        view.fill(expanded: isExpanded)
//
//        didFoldEvent.addListner { isExpanded in
//            view.configure(expanded: isExpanded)
//        }
    }

}
