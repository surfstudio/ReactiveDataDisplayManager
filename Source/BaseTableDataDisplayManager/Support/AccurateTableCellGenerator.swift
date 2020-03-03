//
//  AccurateTableCellGenerator.swift
//  ReactiveDataDisplayManager
//
//  Created by Alexander Filimonov on 03/03/2020.
//  Copyright © 2020 Александр Кравченков. All rights reserved.
//

import Foundation

/// Class for generating reusable Configurable UITableViewCell with calculated height
public class AccurateTableCellGenerator<Cell: AccurateHeight>: BaseTableCellGenerator<Cell> where Cell: UITableViewCell {

    // MARK: - Private Properties

    private let cellWidth: CGFloat

    // MARK: - Initialization

    public init(with model: Cell.Model,
                cellWidth: CGFloat = UIScreen.main.bounds.width,
                registerType: CellRegisterType = .nib) {
        self.cellWidth = cellWidth
        super.init(with: model, registerType: registerType)
    }

    // MARK: - TableCellGenerator

    public var cellHeight: CGFloat {
        return Cell.getHeight(forWidth: cellWidth, with: model)
    }

    public var estimatedCellHeight: CGFloat? {
        return Cell.getHeight(forWidth: cellWidth, with: model)
    }

}

