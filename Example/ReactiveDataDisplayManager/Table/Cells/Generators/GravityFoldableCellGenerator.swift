//
//  GravityFoldableCellGenerator.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 02.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import ReactiveDataDisplayManager

final class GravityFoldableCellGenerator: FoldableItem {

    // MARK: - Properties

    var didFoldEvent = BaseEvent<Bool>()
    var isExpanded = false
    var childGenerators: [TableCellGenerator] = []
    var heaviness: Int

    // MARK: - Initialization

    init(heaviness: Int = .zero) {
        self.heaviness = heaviness
    }

}

// MARK: - TableCellGenerator

extension GravityFoldableCellGenerator: GravityTableCellGenerator {

    var identifier: String {
        return String(describing: FoldableTableViewCell.self)
    }

    func getHeaviness() -> Int {
        return heaviness
    }

}

// MARK: - ViewBuilder

extension GravityFoldableCellGenerator: ViewBuilder {

    func build(view: FoldableTableViewCell) {
        view.fill(title: "with heaviness \(heaviness)", expanded: isExpanded)

        didFoldEvent.addListner { isExpanded in
            view.configure(expanded: isExpanded)
        }
    }

}
