//
//  SectionTitleFooterGenerator.swift
//  ReactiveDataDisplayManagerExample_iOS
//
//  Created by Никита Коробейников on 01.06.2023.
//

import UIKit
import ReactiveDataDisplayManager

final class SectionTitleFooterGenerator: TableFooterGenerator {

    // MARK: - Events

    var willDisplayEvent = Event<Void>()
    var didEndDisplayEvent = Event<Void>()
    var didEndDisplayCellEvent: Event<UITableViewCell>?

    // MARK: - Private Property

    private let model: String
    private lazy var view = HeaderView().fromNib()

    // MARK: - Initialization

    init(model: String) {
        self.model = model
        super.init(uniqueId: model)
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
