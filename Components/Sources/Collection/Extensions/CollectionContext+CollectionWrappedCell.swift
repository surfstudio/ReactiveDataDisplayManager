//
//  CollectionContext+CollectionWrappedCell.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 21.07.2023.
//

import UIKit
import Foundation
import ReactiveDataDisplayManager

extension CollectionContext: BuilderContext {

    public typealias ViewType = UICollectionViewCell
    public typealias GeneratorType = CollectionCellGenerator

    public static func gen<Item>(_ type: Item.Type, model: Item.Model) -> GeneratorType where Item: ConfigurableItem,
                                                                                                Item: RegistrationTypeProvider {
        Item.rddm.collectionGenerator(with: model)
    }

    public static func gen<Item>(_ type: Item.Type, model: Item.Model) -> GeneratorType where Item: ViewType,
                                                                                                Item: ConfigurableItem,
                                                                                                Item: RegistrationTypeProvider {
        Item.rddm.baseGenerator(with: model, and: Item.prefferedRegistration)
    }

    public static func stack(model: StackView.Model) -> CollectionCellGenerator {
        StackView.rddm.collectionGenerator(with: model)
    }

}
