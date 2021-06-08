//
//  CalculatableWidthCollectionCellGenerator.swift
//  ReactiveDataDisplayManager
//
//  Created by Alexander Filimonov on 02/03/2020.
//  Copyright © 2020 Александр Кравченков. All rights reserved.
//

import UIKit

// swiftlint:disable line_length
public class CalculatableWidthCollectionCellGenerator<Cell: ConfigurableItem & CalculatableWidthItem>: BaseCollectionCellGenerator<Cell> & SizableItem where Cell: UICollectionViewCell {
// swiftlint:enable line_length

    // MARK: - Private Properties

    private let height: CGFloat

    // MARK: - Initializaion

    public init(with model: Cell.Model,
                height: CGFloat,
                registerType: CellRegisterType = .nib) {
        self.height = height
        super.init(with: model, registerType: registerType)
    }

    // MARK: - SizableCollectionCellGenerator

    public func getSize() -> CGSize {
        return .init(width: Cell.getWidth(forHeight: height, with: model), height: height)
    }

}
