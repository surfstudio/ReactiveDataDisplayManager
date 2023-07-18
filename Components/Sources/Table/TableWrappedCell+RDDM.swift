//
//  TableWrappedCell+RDDM.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 05.06.2023.
//

import ReactiveDataDisplayManager
import UIKit

public extension StaticDataDisplayWrapper where Base: UIView & ConfigurableItem {

    func tableGenerator(with model: Base.Model,
                        and registerType: CellRegisterType = .nib) -> BaseCellGenerator<TableWrappedCell<Base>> {
        TableWrappedCell<Base>.rddm.baseGenerator(with: model,
                                                  and: registerType)
    }

}

// MARK: - CalculatableHeightItem

public extension StaticDataDisplayWrapper where Base: UIView & ConfigurableItem & CalculatableHeightItem {

    func tableCalculatableHightGenerator(
        with model: Base.Model,
        and registerType: CellRegisterType = .nib
    ) -> CalculatableHeightCellGenerator<TableWrappedCell<Base>> {

        CalculatableHeightCellGenerator<TableWrappedCell<Base>>(with: model,
                                                                registerType: registerType)
    }

}
