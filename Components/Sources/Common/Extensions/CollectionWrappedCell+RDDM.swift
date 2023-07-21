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

// MARK: - CalculatableHeightItem

public extension StaticDataDisplayWrapper where Base: UIView & ConfigurableItem & CalculatableHeightItem {

    func tableCalculatableHightGenerator(
        with model: Base.Model,
        width: CGFloat,
        and registerType: CellRegisterType = .nib
    ) -> CalculatableHeightCollectionCellGenerator<CollectionWrappedCell<Base>> {

        CalculatableHeightCollectionCellGenerator<CollectionWrappedCell<Base>>(with: model,
                                                                               width: width,
                                                                               registerType: registerType)
    }

}

// MARK: - CalculatableWidthItem

public extension StaticDataDisplayWrapper where Base: UIView & ConfigurableItem & CalculatableWidthItem {

    func tableCalculatableWidthGenerator(
        with model: Base.Model,
        height: CGFloat,
        and registerType: CellRegisterType = .nib
    ) -> CalculatableWidthCollectionCellGenerator<CollectionWrappedCell<Base>> {

        CalculatableWidthCollectionCellGenerator<CollectionWrappedCell<Base>>(with: model,
                                                                              height: height,
                                                                              registerType: registerType)
    }

}
