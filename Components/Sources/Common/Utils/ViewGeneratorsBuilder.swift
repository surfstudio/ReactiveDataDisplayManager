//
//  ViewGeneratorsBuilder.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 20.07.2023.
//

import UIKit
import Foundation
import ReactiveDataDisplayManager

public enum ViewFactory {

    public static func stack(model: StackView.Model) -> StackCellGenerator {
        StackView.rddm.viewGenerator(with: model, and: .class)
    }

    public static func viewClass<T: UIView & ConfigurableItem>(type: T.Type,
                                                               model: T.Model) -> BaseViewGenerator<T> {
        T.rddm.viewGenerator(with: model, and: .class)
    }
    
    public static func viewNib<T: UIView & ConfigurableItem>(type: T.Type,
                                                             model: T.Model) -> BaseViewGenerator<T> {
        T.rddm.viewGenerator(with: model, and: .nib)
    }

}

// MARK: - Table

public enum TableFactory {

    public static func stack(model: StackView.Model) -> TableCellGenerator {
        StackView.rddm.tableGenerator(with: model, and: .class)
    }

    public static func cell<T: UITableViewCell & ConfigurableItem>(type: T.Type,
                                                                   model: T.Model,
                                                                   registerType: CellRegisterType) -> BaseCellGenerator<T> {
        T.rddm.baseGenerator(with: model, and: registerType)
    }

    public static func viewNib<T: UIView & ConfigurableItem>(type: T.Type,
                                                             model: T.Model) -> BaseCellGenerator<TableWrappedCell<T>> {
        T.rddm.tableGenerator(with: model, and: .nib)
    }

    public static func viewClass<T: UIView & ConfigurableItem>(type: T.Type,
                                                               model: T.Model) -> BaseCellGenerator<TableWrappedCell<T>> {
        T.rddm.tableGenerator(with: model, and: .class)
    }

}

// MARK: - Collection

public enum CollectionFactory {

    public static func stack(model: StackView.Model) -> CollectionCellGenerator {
        StackView.rddm.collectionGenerator(with: model, and: .class)
    }

    public static func cell<T: UICollectionViewCell & ConfigurableItem>(type: T.Type,
                                                                        model: T.Model,
                                                                        registerType: CellRegisterType) -> BaseCollectionCellGenerator<T> {
        T.rddm.baseGenerator(with: model, and: registerType)
    }
    
    public static func viewNib<T: UICollectionViewCell & ConfigurableItem>(type: T.Type,
                                                                           model: T.Model) -> BaseCollectionCellGenerator<CollectionWrappedCell<T>> {
        T.rddm.collectionGenerator(with: model, and: .nib)
    }
    
    public static func viewClass<T: UICollectionViewCell & ConfigurableItem>(type: T.Type,
                                                                             model: T.Model) -> BaseCollectionCellGenerator<CollectionWrappedCell<T>> {
        T.rddm.collectionGenerator(with: model, and: .class)
    }

}
