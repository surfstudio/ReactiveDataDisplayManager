//
//  Decoration+Provider.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 22.05.2023.
//

import UIKit
import ReactiveDataDisplayManager

extension Decoration {

    var tableProvider: any DecorationProvider {
        switch self {
        case .space(let model):
            return TableDecorationProvider<TableSpacerCell>(model: model,
                                                            hash: "space",
                                                            hashCombiner: CommonHashCombiner())
        }
    }

    var collectionProvider: any DecorationProvider {
        switch self {
        case .space(let model):
            return CollectionDecorationProvider<CollectionSpacerCell>(model: model,
                                                                      hash: "space",
                                                                      hashCombiner: CommonHashCombiner())
        }
    }

}
