//
//  TitleCellGenerator.swift
//  ReactiveDataDisplayManagerExample_iOS
//
//  Created by porohov on 07.06.2022.
//

import ReactiveDataDisplayManager

class TitleTableCellGenerator: BaseCellGenerator<TitleTableViewCell> {

    // MARK: - Properties

    var cell: TitleTableViewCell?
    let string: String

    // MARK: - Initialization

    init(string: String) {
        self.string = string
        super.init(with: string)
    }

    // MARK: - BaseCellGenerator

    override func configure(cell: TitleTableViewCell, with model: String) {
        self.cell = cell
        super.configure(cell: cell, with: string)
    }

}
