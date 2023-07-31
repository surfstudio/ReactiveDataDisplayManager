//
//  CollectionContext.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 21.07.2023.
//

import UIKit
import Foundation

public struct CollectionContext: BuilderContext {

    public typealias ViewType = UICollectionViewCell
    public typealias CellsBuilder = (CollectionContext.Type) -> [CollectionCellGenerator]

    public static func gen<Item>(_ type: Item.Type, model: Item.Model) -> BaseCellGenerator<CollectionWrappedCell<Item>> where Item: BaseItem {
        Item.rddm.collectionGenerator(with: model)
    }

    public static func gen<Item>(_ type: Item.Type, model: Item.Model) -> BaseCellGenerator<Item> where Item: ViewType & BaseItem {
        Item.rddm.baseGenerator(with: model, and: Item.prefferedRegistration)
    }

}
