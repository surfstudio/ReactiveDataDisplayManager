//
//  SectionTitleFooterGenerator.swift
//  ReactiveDataDisplayManagerExample_iOS
//
//  Created by Никита Коробейников on 01.06.2023.
//

import UIKit
import ReactiveDataDisplayManager

final class SectionTitleFooterGenerator: TableFooterGenerator {

    // MARK: - Constants

    private enum Constants {
        static let defaultHeight: CGFloat = 24
    }

    // MARK: - Events

    var willDisplayEvent = BaseEvent<Void>()
    var didEndDisplayEvent = BaseEvent<Void>()
    var didEndDisplayCellEvent: BaseEvent<UITableViewCell>?

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
        view?.frame.height ?? Constants.defaultHeight
    }

}
