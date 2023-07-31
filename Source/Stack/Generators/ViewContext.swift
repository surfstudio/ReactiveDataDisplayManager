//
//  ViewContext.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 21.07.2023.
//

import UIKit
import Foundation

/// Context which is used to build `UIView` which can be used as child for `StackView`
public struct ViewContext: BuilderContext {

    public typealias ViewType = UIView
    public typealias CellsBuilder = (ViewContext.Type) -> [ViewGenerator]

    /// This method is used to build generator for some `UIView` which can be used as child for `StackView`
    ///  - Parameters:
    ///   - type: may be `SomeView.self`
    ///   - model: configurable model for generic `SomeView`
    public static func gen<Item>(_ type: Item.Type, model: Item.Model) -> BaseViewGenerator<Item> where Item: BaseItem {
        Item.rddm.viewGenerator(with: model, and: Item.prefferedRegistration)
    }

}
