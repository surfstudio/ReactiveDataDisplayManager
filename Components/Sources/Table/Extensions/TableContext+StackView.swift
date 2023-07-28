//
//  StackView+TableContext.swift
//  ReactiveChat_iOS
//
//  Created by Никита Коробейников on 28.07.2023.
//

import ReactiveDataDisplayManager

public extension TableContext {

    static func stack(model: StackView.Model) -> TableCellGenerator {
        StackView.rddm.tableGenerator(with: model)
    }

}
