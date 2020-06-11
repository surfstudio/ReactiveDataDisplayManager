//
//  BaseCollectionCellGenerator.swift
//  ReactiveDataDisplayManager
//
//  Created by Maxim MAMEDOV on 28/03/2019.
//  Copyright © 2019 Александр Кравченков. All rights reserved.
//

import Foundation

public class BaseCollectionCellGenerator<Cell: Configurable>: SelectableItem where Cell: UICollectionViewCell {

    // MARK: - Public Properties

    public var didSelectEvent = BaseEvent<Void>()
    public let model: Cell.Model

    // MARK: - Private Properties

    private let registerType: CellRegisterType

    // MARK: - Initialization

    public init(with model: Cell.Model,
                registerType: CellRegisterType = .nib) {
        self.model = model
        self.registerType = registerType
    }

}

// MARK: - CollectionCellGenerator

extension BaseCollectionCellGenerator: CollectionCellGenerator {
    public var identifier: UICollectionViewCell.Type {
        return Cell.self
    }

    public func generate(collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier.nameOfClass, for: indexPath) as? Cell else {
            return UICollectionViewCell()
        }
        cell.configure(with: model)
        return cell
    }

    public func registerCell(in collectionView: UICollectionView) {
        switch registerType {
        case .nib:
            collectionView.registerNib(identifier)
        case .class:
            collectionView.register(identifier, forCellWithReuseIdentifier: identifier.nameOfClass)
        }
    }
}
