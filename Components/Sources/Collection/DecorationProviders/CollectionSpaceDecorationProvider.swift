//
//  CollectionSpaceDecorationProvider.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 22.05.2023.
//

import UIKit
import ReactiveDataDisplayManager

final class CollectionSpaceDecorationProvider: DecorationProvider {

    typealias GeneratorType = DiffableCollectionCellGenerator<CollectionSpacerCell>

    private let model: SpacerView.Model

    init(model: SpacerView.Model) {
        self.model = model
    }

    func provideDecoration(with parentId: AnyHashable) -> DiffableCollectionCellGenerator<CollectionSpacerCell> {
        var hasher = Hasher()
        hasher.combine(parentId)
        hasher.combine("space")
        return .init(uniqueId: hasher.finalize(), with: model)
    }

}
