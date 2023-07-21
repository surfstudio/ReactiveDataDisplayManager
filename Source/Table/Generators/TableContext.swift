//
//  TableContext.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 21.07.2023.
//

import UIKit
import Foundation

public enum TableContext {

    public static func cell<T: UITableViewCell & ConfigurableItem>(type: T.Type,
                                                                   model: T.Model,
                                                                   registerType: CellRegisterType) -> BaseCellGenerator<T> {
        T.rddm.baseGenerator(with: model, and: registerType)
    }

    // TODO: - add support for other types of generators or make (decorated generator)
}
