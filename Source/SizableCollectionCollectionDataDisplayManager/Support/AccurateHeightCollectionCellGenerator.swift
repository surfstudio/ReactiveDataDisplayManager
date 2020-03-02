//
//  AccurateHeightCollectionCellGenerator.swift
//  ReactiveDataDisplayManager
//
//  Created by Alexander Filimonov on 02/03/2020.
//  Copyright © 2020 Александр Кравченков. All rights reserved.
//

import Foundation

public class AccurateHeightCollectionCellGenerator<Cell: Configurable & AccurateHeight>: BaseCollectionCellGenerator<Cell> & SizableCollectionCellGenerator where Cell: UICollectionViewCell {

    // MARK: - Private Properties]

    private let width: CGFloat

    // MARK: - Initializaion

    init(with model: Cell.Model,
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
