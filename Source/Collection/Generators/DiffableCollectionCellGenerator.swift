//
//  DiffableCollectionCellGenerator.swift
//  ReactiveDataDisplayManager
//
//  Created by korshunov on 25.02.2022.
//

import UIKit

public class DiffableCollectionCellGenerator<Cell: ConfigurableItem>: BaseCollectionCellGenerator<Cell>, DiffableItemSource where Cell: UICollectionViewCell, Cell.Model: Equatable {

    private let id: String

    public var diffableItem: DiffableItem {
        .init(id: id, state: AnyEquatable(model))
    }

    public init(uniqueId: String, with model: Cell.Model, registerType: CellRegisterType = .nib) {
        self.id = uniqueId
        super.init(with: model, registerType: registerType)
    }

}

extension StaticDataDisplayWrapper where Base: UICollectionViewCell & ConfigurableItem, Base.Model: Equatable {

    public func diffableGenerator(
        uniqueId: String,
        with model: Base.Model,
        and registerType: CellRegisterType = .nib
    ) -> DiffableCollectionCellGenerator<Base> {
        .init(uniqueId: uniqueId, with: model, registerType: registerType)
    }

}

/// Protocol for Model contains `id` property
public protocol IdOwner {
    var id: String { get }
}

extension StaticDataDisplayWrapper where Base: UICollectionViewCell & ConfigurableItem, Base.Model: Equatable & IdOwner {

    public func diffableGenerator(
        with model: Base.Model,
        and registerType: CellRegisterType = .nib
    ) -> DiffableCollectionCellGenerator<Base> {
        .init(uniqueId: model.id, with: model, registerType: registerType)
    }

}



