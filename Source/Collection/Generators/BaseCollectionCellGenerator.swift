//
//  BaseCollectionCellGenerator.swift
//  ReactiveDataDisplayManager
//
//  Created by Maxim MAMEDOV on 28/03/2019.
//  Copyright © 2019 Александр Кравченков. All rights reserved.
//

import UIKit

open class BaseCollectionCellGenerator<Cell: ConfigurableItem>: SelectableItem where Cell: UICollectionViewCell {

    // MARK: - Public Properties

    public var isNeedDeselect = true
    public var didSelectEvent = EmptyEvent()
    public var didDeselectEvent = EmptyEvent()
    public let model: Cell.Model

    // MARK: - Private Properties

    private let registerType: RegistrationType

    // MARK: - Initialization

    public init(with model: Cell.Model,
                registerType: RegistrationType = .nib) {
        self.model = model
        self.registerType = registerType
    }

    // MARK: - Open methods

    open func configure(cell: Cell, with model: Cell.Model) {
        cell.configure(with: model)
    }

}

// MARK: - CollectionCellGenerator

extension BaseCollectionCellGenerator: CollectionCellGenerator {

    public var identifier: String {
        return String(describing: Cell.self)
    }

    public func generate(collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? Cell else {
            return UICollectionViewCell()
        }
        configure(cell: cell, with: model)
        return cell
    }

    public func registerCell(in collectionView: UICollectionView) {
        switch registerType {
        case .nib:
            collectionView.registerNib(identifier, bundle: Cell.bundle())
        case .class:
            collectionView.register(Cell.self, forCellWithReuseIdentifier: identifier)
        }
    }

}
