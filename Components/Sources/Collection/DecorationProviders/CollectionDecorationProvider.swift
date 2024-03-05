//
//  CollectionDecorationProvider.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 23.05.2023.
//

import UIKit
import ReactiveDataDisplayManager

final class CollectionDecorationProvider<Cell: ConfigurableItem & UICollectionViewCell>: DecorationProvider where Cell.Model: Equatable {

    typealias GeneratorType = DiffableCellGenerator<Cell>

    // MARK: - Properties

    private let hashCombiner: HashCombiner
    private let hash: AnyHashable
    private let model: Cell.Model

    // MARK: - Initialisation

    init(model: Cell.Model, hash: AnyHashable, hashCombiner: HashCombiner) {
        self.model = model
        self.hash = hash
        self.hashCombiner = hashCombiner
    }

    // MARK: - DecorationProvider

    func provideDecoration(with parentId: AnyHashable) -> GeneratorType {
        Cell.rddm.diffableGenerator(uniqueId: hashCombiner.combine(first: parentId,
                                                                   with: hash),
                                    with: model,
                                    and: .class)
    }

}
