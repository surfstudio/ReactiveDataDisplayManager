//
//  TableWrappedCell+RDDM.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 05.06.2023.
//

import ReactiveDataDisplayManager
import UIKit

public extension StaticDataDisplayWrapper where Base: UIView & ConfigurableItem & RegistrationTypeProvider {

    func tableGenerator(with model: Base.Model) -> BaseCellGenerator<TableWrappedCell<Base>> {
        TableWrappedCell<Base>.rddm.baseGenerator(with: model,
                                                  and: .class)
    }

}

// MARK: - CalculatableHeightItem

public extension StaticDataDisplayWrapper where Base: UIView & ConfigurableItem & CalculatableHeightItem & RegistrationTypeProvider {

    func tableCalculatableHightGenerator(
        with model: Base.Model,
        and registerType: RegistrationType = .nib
    ) -> CalculatableHeightCellGenerator<TableWrappedCell<Base>> {

        CalculatableHeightCellGenerator<TableWrappedCell<Base>>(with: model,
                                                                registerType: registerType)
    }

}
