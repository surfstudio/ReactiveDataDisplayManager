//
//  ConfigurableItem+Context.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 26.07.2023.
//

import ReactiveDataDisplayManager

public extension ConfigurableItem {

    static func build<T: BuilderContext>(in context: T.Type, with model: Self.Model) -> T.GeneratorType? {
        // TODO: - TBD
        return nil
    }

}
