//
//  PrefetchableTableCellGeneratorMock.swift
//  ReactiveDataDisplayManager
//
//  Created by porohov on 21.06.2022.
//

import UIKit

@testable import ReactiveDataDisplayManager

final class PrefetchableTableCellGeneratorMock: BaseCellGenerator<TableViewCellMock>, PrefetcherableItem {

    // MARK: - PrefetcherableFlow

    var requestId: Int?

    // MARK: - BaseCellGenerator

    init(with model: Bool, requestId: Int) {
        self.requestId = requestId
        super.init(with: model)
    }

}

final class TableViewCellMock: UITableViewCell, ConfigurableItem {

    // MARK: - Properties

    var isLoaded = false

    // MARK: - ConfigurableItem

    func configure(with model: Bool) {
        isLoaded = model
    }

}
