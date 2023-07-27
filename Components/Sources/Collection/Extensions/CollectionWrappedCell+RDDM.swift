//
//  CollectionWrappedCell+RDDM.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 05.06.2023.
//

import ReactiveDataDisplayManager
import UIKit

public extension StaticDataDisplayWrapper where Base: UIView & ConfigurableItem & RegistrationTypeProvider {

    func collectionGenerator(with model: Base.Model) -> BaseCollectionCellGenerator<CollectionWrappedCell<Base>> {
        CollectionWrappedCell<Base>.rddm.baseGenerator(with: model,
                                                       and: .class)
    }

}

// MARK: - CalculatableHeightItem

public extension StaticDataDisplayWrapper where Base: UIView & ConfigurableItem & CalculatableHeightItem & RegistrationTypeProvider {

    func tableCalculatableHightGenerator(
        with model: Base.Model,
        width: CGFloat,
        and registerType: RegistrationType = .nib
    ) -> CalculatableHeightCollectionCellGenerator<CollectionWrappedCell<Base>> {

        CalculatableHeightCollectionCellGenerator<CollectionWrappedCell<Base>>(with: model,
                                                                               width: width,
                                                                               registerType: registerType)
    }

}

// MARK: - CalculatableWidthItem

public extension StaticDataDisplayWrapper where Base: UIView & ConfigurableItem & CalculatableWidthItem & RegistrationTypeProvider {

    func tableCalculatableWidthGenerator(
        with model: Base.Model,
        height: CGFloat,
        and registerType: RegistrationType = .nib
    ) -> CalculatableWidthCollectionCellGenerator<CollectionWrappedCell<Base>> {

        CalculatableWidthCollectionCellGenerator<CollectionWrappedCell<Base>>(with: model,
                                                                              height: height,
                                                                              registerType: registerType)
    }

}
