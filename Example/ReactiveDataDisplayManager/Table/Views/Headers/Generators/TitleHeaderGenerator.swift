//
//  TitleHeaderGenerator.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 02.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import ReactiveDataDisplayManager
import UIKit

final class TitleHeaderGenerator: TableHeaderGenerator {

    // MARK: - Private Property

    private let model: String
    private lazy var view = HeaderView().fromNib()

    // MARK: - Initialization

    init(model: String) {
        self.model = model
    }

    // MARK: - TableHeaderGenerator

    override func generate() -> UIView {
        guard let view = view else { return UIView() }
        view.configure(with: model)
        return view
    }

    override func height(_ tableView: UITableView, forSection section: Int) -> CGFloat {
        HeaderView.getHeight(forWidth: tableView.bounds.width, with: model)
    }

}

// MARK: - Diffable

extension TitleHeaderGenerator: DiffableItemSource {

    var diffableItem: DiffableItem {
        DiffableItem(id: uuid, state: .init(model))
    }

}
