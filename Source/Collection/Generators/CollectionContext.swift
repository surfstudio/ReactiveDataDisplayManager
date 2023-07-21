//
//  CollectionContext.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 21.07.2023.
//

import UIKit
import Foundation

public enum CollectionContext {

    public static func cell<T: UICollectionViewCell & ConfigurableItem>(type: T.Type,
                                                                        model: T.Model,
                                                                        registerType: CellRegisterType) -> BaseCollectionCellGenerator<T> {
        T.rddm.baseGenerator(with: model, and: registerType)
    }

    // TODO: - add support for other types of generators or make (decorated generator)
}
