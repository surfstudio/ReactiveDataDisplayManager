//
//  BaseCollectionCellGenerator.swift
//  ReactiveDataDisplayManager
//
//  Created by Maxim MAMEDOV on 28/03/2019.
//  Copyright © 2019 Александр Кравченков. All rights reserved.
//

import Foundation

public class BaseCollectionCellGenerator<Cell: Configurable>: SelectableItem where Cell: UICollectionViewCell {

    // MARK: - Properties

    public var didSelectEvent = BaseEvent<Void>()

    // MARK: - Private properties

    private let model: Cell.Model
    private let registerClass: Bool

    // MARK: - Initialization

    public init(with model: Cell.Model, registerClass: Bool = false) {
        self.model = model
        self.registerClass = registerClass
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
        if registerClass {
            collectionView.register(identifier, forCellWithReuseIdentifier: identifier.nameOfClass)
        } else {
            collectionView.registerNib(identifier)
        }
    }
}
