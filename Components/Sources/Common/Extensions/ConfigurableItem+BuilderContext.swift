//
//  ConfigurableItem+BuilderContext.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 26.07.2023.
//

import UIKit
import ReactiveDataDisplayManager

public extension ConfigurableItem where Self: RegistrationTypeProvider {
    
    static func build<Context: BuilderContext>(in ctx: Context.Type, with model: Model) -> Context.GeneratorType {
        ctx.gen(Self.self, model: model)
    }
    
}
