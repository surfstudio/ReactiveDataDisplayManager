//
//  SectionTitleHeaderGenerator.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 08.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager

final class SectionTitleHeaderGenerator: TableHeaderGenerator, IndexTitleDisplaybleItem {

    // MARK: - Events

    var willDisplayEvent = Event<Void>()
    var didEndDisplayEvent = Event<Void>()
    var didEndDisplayCellEvent: Event<UITableViewCell>?

    // MARK: - Properties

    var title: String
    var needIndexTitle: Bool

    // MARK: - Private Property

    private let model: String
    private lazy var view = HeaderView().fromNib()

    // MARK: - Initialization

    init(model: String, needSectionIndexTitle: Bool) {
        self.model = model
        self.title = model
        self.needIndexTitle = needSectionIndexTitle
        super.init()
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
