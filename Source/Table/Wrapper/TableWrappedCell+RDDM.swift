//
//  TableWrappedCell+RDDM.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 05.06.2023.
//

import UIKit

public extension StaticDataDisplayWrapper where Base: UIView & BaseItem {

    func tableGenerator(with model: Base.Model) -> BaseCellGenerator<TableWrappedCell<Base>> {
        TableWrappedCell<Base>.rddm.baseGenerator(with: model, and: .class)
    }

}

public extension StaticDataDisplayWrapper where Base: UITableViewCell & BaseItem {

    func tableGenerator(with model: Base.Model) -> BaseCellGenerator<Base> {
        Base.rddm.baseGenerator(with: model, and: Base.prefferedRegistration)
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
