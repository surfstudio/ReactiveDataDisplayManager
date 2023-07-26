//
//  ViewContext.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 21.07.2023.
//

import UIKit
import Foundation

public struct ViewContext: BuilderContext {

    public typealias ViewType = UIView
    public typealias GeneratorType = ViewGenerator

    public static func gen<Item>(_ type: Item.Type, model: Item.Model) -> GeneratorType where Item : ConfigurableItem, Item : RegistrationTypeProvider {
        Item.rddm.viewGenerator(with: model, and: Item.prefferedRegistration)
    }

    @available(*, deprecated, renamed: "gen", message: "Please use `gen` method and `RegistrationTypeProvider` instead")
    public static func viewClass<T: UIView & ConfigurableItem>(type: T.Type,
                                                               model: T.Model) -> BaseViewGenerator<T> {
        T.rddm.viewGenerator(with: model, and: .class)
    }

    @available(*, deprecated, renamed: "gen", message: "Please use `gen` method and `RegistrationTypeProvider` instead")
    public static func viewNib<T: UIView & ConfigurableItem>(type: T.Type,
                                                             model: T.Model) -> BaseViewGenerator<T> {
        T.rddm.viewGenerator(with: model, and: .nib)
    }

}
