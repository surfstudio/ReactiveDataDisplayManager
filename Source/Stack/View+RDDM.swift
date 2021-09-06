//
//  View+RDDM.swift
//  Pods
//
//  Created by Никита Коробейников on 06.09.2021.
//

public extension StaticDataDisplayWrapper where Base: ConfigurableItem {

    func baseStackGenerator(with model: Base.Model) -> BaseStackCellGenerator<Base> {
        .init(with: model)
    }

}
