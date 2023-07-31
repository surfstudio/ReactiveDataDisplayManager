//
//  CollectionContext.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 21.07.2023.
//

import UIKit
import Foundation

/// Context which is used to prepare generators for `UIView` or `UICollectionViewCell` to place them into `UICollectionView`
public struct CollectionContext: BuilderContext {

    public typealias ViewType = UICollectionViewCell
    public typealias CellsBuilder = (CollectionContext.Type) -> [CollectionCellGenerator]

    /// This method is used to build generator for some `UIView` to place it in `UICollectionView`
    ///  - Parameters:
    ///   - type: may be `SomeView.self`
    ///   - model: configurable model for generic `SomeView`
    public static func gen<Item>(_ type: Item.Type, model: Item.Model) -> BaseCellGenerator<CollectionWrappedCell<Item>> where Item: BaseItem {
        Item.rddm.collectionGenerator(with: model)
    }

    /// This method is used to build generator for some `UICollectionViewCell` to place it in `UICollectionView`
    ///  - Parameters:
    ///   - type: may be `SomeCell.self`
    ///   - model: configurable model for generic `SomeCell`
    public static func gen<Item>(_ type: Item.Type, model: Item.Model) -> BaseCellGenerator<Item> where Item: ViewType & BaseItem {
        Item.rddm.baseGenerator(with: model, and: Item.prefferedRegistration)
    }

}
