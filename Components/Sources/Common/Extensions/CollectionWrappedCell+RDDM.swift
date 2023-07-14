//
//  CollectionWrappedCell+RDDM.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 05.06.2023.
//

import ReactiveDataDisplayManager
import UIKit

public extension StaticDataDisplayWrapper where Base: UIView & ConfigurableItem {

    func collectionGenerator(with model: Base.Model,
                             and registerType: CellRegisterType = .nib) -> BaseCollectionCellGenerator<CollectionWrappedCell<Base>> {
        CollectionWrappedCell<Base>.rddm.baseGenerator(with: model,
                                                       and: registerType)
    }

}
