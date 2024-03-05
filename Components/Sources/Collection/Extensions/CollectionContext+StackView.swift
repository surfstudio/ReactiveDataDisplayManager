//
//  StackView+CollectionContext.swift
//  ReactiveChat_iOS
//
//  Created by Никита Коробейников on 28.07.2023.
//

import ReactiveDataDisplayManager

public extension CollectionContext {

    /// Used to place `StackView` into other `UICollectionView` as cell
    /// - Parameter model: model which contains styles and children
    static func stack(model: StackView.Model) -> BaseCellGenerator<CollectionWrappedCell<StackView>> {
        StackView.rddm.collectionGenerator(with: model)
    }

}
