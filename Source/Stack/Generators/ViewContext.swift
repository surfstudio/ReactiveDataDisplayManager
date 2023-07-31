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
    public typealias CellsBuilder = (ViewContext.Type) -> [ViewGenerator]

    public static func gen<Item>(_ type: Item.Type, model: Item.Model) -> BaseViewGenerator<Item> where Item: BaseItem {
        Item.rddm.viewGenerator(with: model, and: Item.prefferedRegistration)
    }

}
