//
//  CalculatableHeightCollectionCellGenerator.swift
//  ReactiveDataDisplayManager
//
//  Created by Alexander Filimonov on 02/03/2020.
//  Copyright © 2020 Александр Кравченков. All rights reserved.
//

import UIKit

public class CalculatableHeightCollectionCellGenerator<Cell: RDDMConfigurableItem & RDDMCalculatableHeightItem>: BaseCollectionCellGenerator<Cell> & RDDMSizableItem where Cell: UICollectionViewCell {

    // MARK: - Private Properties

    private let width: CGFloat

    // MARK: - Initializaion

    public init(with model: Cell.Model,
                width: CGFloat,
                registerType: CellRegisterType = .nib) {
        self.width = width
        super.init(with: model, registerType: registerType)
    }

    // MARK: - SizableCollectionCellGenerator

    public func getSize() -> CGSize {
        return .init(width: width, height: Cell.getHeight(forWidth: width, with: model))
    }

}
