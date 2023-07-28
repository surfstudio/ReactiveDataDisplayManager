//
//  StackView+CollectionContext.swift
//  ReactiveChat_iOS
//
//  Created by Никита Коробейников on 28.07.2023.
//

import ReactiveDataDisplayManager

public extension CollectionContext {

    static func stack(model: StackView.Model) -> CollectionCellGenerator {
        StackView.rddm.collectionGenerator(with: model)
    }

}
