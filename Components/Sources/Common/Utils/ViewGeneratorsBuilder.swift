//
//  ViewGeneratorsBuilder.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 20.07.2023.
//

import Foundation
import ReactiveDataDisplayManager

public func Stack(model: StackView.Model,
    @GeneratorsBuilder<StackCellGenerator>_ content: () -> [StackCellGenerator]
) -> TableCellGenerator {
    StackView.rddm.tableGenerator(with: .copy(of: model) { property in
        property.children(content())
    }, and: .class)
}
