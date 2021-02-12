//
//  TitleTableGenerator.swift
//  ReactiveDataDisplayManager
//
//  Created by Ivan Smetanin on 19/12/2017.
//  Copyright © 2017 Alexander Kravchenkov. All rights reserved.
//

import ReactiveDataDisplayManager

class TitleTableGenerator: SelectableItem, SwipeableItem {

    // MARK: - Events

    var didSelectEvent = BaseEvent<Void>()
    var didSwipeEvent = BaseEvent<String>()

    // MARK: - Stored properties

    var actionTypes = [String]()
    var didSelected: Bool = false
    var isNeedDeselect: Bool = true
    fileprivate let model: String

    // MARK: - Initializers

    public init(model: String) {
        self.model = model
    }

}

// MARK: - TableCellGenerator

extension TitleTableGenerator: TableCellGenerator {

    var identifier: String {
        return String(describing: TitleTableViewCell.self) 
    }

}

// MARK: - ViewBuilder

extension TitleTableGenerator: ViewBuilder {

    func build(view: TitleTableViewCell) {
        view.fill(with: model)
    }
}
