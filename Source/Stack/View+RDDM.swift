//
//  View+RDDM.swift
//  Pods
//
//  Created by Никита Коробейников on 06.09.2021.
//

import UIKit

public extension StaticDataDisplayWrapper where Base: ConfigurableItem {

    func viewGenerator(with model: Base.Model, and registerType: RegistrationType = .class) -> BaseViewGenerator<Base> {
        .init(with: model, registerType: registerType)
    }

}
