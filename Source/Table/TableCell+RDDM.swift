//
//  TableCell+RDDM.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 20.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

public extension StaticDataDisplayWrapper where Base: UITableViewCell & ConfigurableItem {

    func baseGenerator(with model: Base.Model, and registerType: RegistrationType = .nib) -> BaseCellGenerator<Base> {
        .init(with: model, registerType: registerType)
    }

}

public extension StaticDataDisplayWrapper where Base: UITableViewCell & ConfigurableItem & FoldableStateHolder {

    func foldableGenerator(with model: Base.Model, and registerType: RegistrationType = .nib) -> FoldableCellGenerator<Base> {
        .init(with: model, registerType: registerType)
    }

}

public extension StaticDataDisplayWrapper where Base: UITableViewCell & ConfigurableItem & ConstractableItem {

    func nonReusableGenerator(with model: Base.Model) -> BaseNonReusableCellGenerator<Base> {
        .init(with: model)
    }

}

public extension StaticDataDisplayWrapper where Base: UITableViewCell & ConfigurableItem & CalculatableHeightItem {

    func calculatableHeightGenerator(with model: Base.Model,
                                     and registerType: RegistrationType = .nib,
                                     referenceWidth: CGFloat = UIScreen.main.bounds.width) -> CalculatableHeightCellGenerator<Base> {
        .init(with: model, cellWidth: referenceWidth, registerType: registerType)
    }

}
