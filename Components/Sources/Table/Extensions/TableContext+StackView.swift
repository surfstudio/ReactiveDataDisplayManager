//
//  StackView+TableContext.swift
//  ReactiveChat_iOS
//
//  Created by Никита Коробейников on 28.07.2023.
//

import ReactiveDataDisplayManager

public extension TableContext {

    /// Used to place `StackView` into other `UITableView` as cell
    /// - Parameter model: model which contains styles and children
    static func stack(model: StackView.Model) -> BaseCellGenerator<TableWrappedCell<StackView>> {
        StackView.rddm.tableGenerator(with: model)
    }

}
