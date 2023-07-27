//
//  TableContext+TableWrappedCell.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 21.07.2023.
//

import UIKit
import Foundation
import ReactiveDataDisplayManager

extension TableContext: BuilderContext {

    public typealias ViewType = UITableViewCell
    public typealias GeneratorType = TableCellGenerator

    public static func gen<Item>(_ type: Item.Type, model: Item.Model) -> GeneratorType where Item: ConfigurableItem,
                                                                                                Item: RegistrationTypeProvider {
        Item.rddm.tableGenerator(with: model)
    }

    public static func gen<Item>(_ type: Item.Type, model: Item.Model) -> GeneratorType where Item: ViewType,
                                                                                                Item: ConfigurableItem,
                                                                                                Item: RegistrationTypeProvider {
        Item.rddm.baseGenerator(with: model, and: Item.prefferedRegistration)
    }

    public static func stack(model: StackView.Model) -> TableCellGenerator {
        StackView.rddm.tableGenerator(with: model)
    }

}
