//
//  TableContext+TableWrappedCell.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 21.07.2023.
//

import UIKit
import Foundation
import ReactiveDataDisplayManager

public extension TableContext {

    static func stack(model: StackView.Model) -> TableCellGenerator {
        StackView.rddm.tableGenerator(with: model, and: .class)
    }

    static func viewNib<T: UIView & ConfigurableItem>(type: T.Type,
                                                      model: T.Model) -> BaseCellGenerator<TableWrappedCell<T>> {
        T.rddm.tableGenerator(with: model, and: .nib)
    }

    static func viewClass<T: UIView & ConfigurableItem>(type: T.Type,
                                                        model: T.Model) -> BaseCellGenerator<TableWrappedCell<T>> {
        T.rddm.tableGenerator(with: model, and: .class)
    }

}
