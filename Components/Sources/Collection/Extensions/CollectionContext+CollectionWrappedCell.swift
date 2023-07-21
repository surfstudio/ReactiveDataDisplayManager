//
//  CollectionContext+CollectionWrappedCell.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 21.07.2023.
//

import UIKit
import Foundation
import ReactiveDataDisplayManager

public extension CollectionContext {

    static func stack(model: StackView.Model) -> CollectionCellGenerator {
        StackView.rddm.collectionGenerator(with: model, and: .class)
    }

    static func viewNib<T: UICollectionViewCell & ConfigurableItem>(type: T.Type,
                                                                    model: T.Model) -> BaseCollectionCellGenerator<CollectionWrappedCell<T>> {
        T.rddm.collectionGenerator(with: model, and: .nib)
    }

    static func viewClass<T: UICollectionViewCell & ConfigurableItem>(type: T.Type,
                                                                      model: T.Model) -> BaseCollectionCellGenerator<CollectionWrappedCell<T>> {
        T.rddm.collectionGenerator(with: model, and: .class)
    }

}
