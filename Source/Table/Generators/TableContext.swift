//
//  TableContext.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 21.07.2023.
//

import UIKit
import Foundation

public struct TableContext: BuilderContext {

    public typealias ViewType = UITableViewCell
    public typealias GeneratorType = TableCellGenerator

    public static func gen<Item>(_ type: Item.Type, model: Item.Model) -> GeneratorType where Item: BaseItem {
        Item.rddm.tableGenerator(with: model)
    }

    public static func gen<Item>(_ type: Item.Type, model: Item.Model) -> any GeneratorType where Item: ViewType,
                                                                                                Item: BaseItem {
        Item.rddm.baseGenerator(with: model, and: Item.prefferedRegistration)
    }

}
