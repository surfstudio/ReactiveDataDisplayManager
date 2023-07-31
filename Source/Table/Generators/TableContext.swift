//
//  TableContext.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 21.07.2023.
//

import UIKit
import Foundation

/// Context which is used to prepare generators for `UIView` or `UITableViewCell` to place them into `UITableView`
public struct TableContext: BuilderContext {

    public typealias ViewType = UITableViewCell
    public typealias CellsBuilder = (TableContext.Type) -> [TableCellGenerator]

    /// This method is used to build generator for some `UIView` to place it in `UITableView`
    ///  - Parameters:
    ///   - type: may be `SomeView.self`
    ///   - model: configurable model for generic `SomeView`
    public static func gen<Item>(_ type: Item.Type, model: Item.Model) -> BaseCellGenerator<TableWrappedCell<Item>> where Item: BaseItem {
        Item.rddm.tableGenerator(with: model)
    }

    /// This method is used to build generator for some `UITableViewCell` to place it in `UITableView`
    ///  - Parameters:
    ///   - type: may be `SomeCell.self`
    ///   - model: configurable model for generic `SomeCell`
    public static func gen<Item>(_ type: Item.Type, model: Item.Model) -> BaseCellGenerator<Item> where Item: ViewType & BaseItem {
        Item.rddm.baseGenerator(with: model, and: Item.prefferedRegistration)
    }

}
