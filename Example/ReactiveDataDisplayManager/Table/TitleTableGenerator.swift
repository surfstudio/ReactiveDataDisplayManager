//
//  TitleTableGenerator.swift
//  ReactiveDataDisplayManager
//
//  Created by Ivan Smetanin on 19/12/2017.
//  Copyright © 2017 Alexander Kravchenkov. All rights reserved.
//

import ReactiveDataDisplayManager

class TitleTableGenerator: SelectableItem {

    // MARK: - Events

    var didSelectEvent = BaseEvent<Void>()

    // MARK: - Stored properties

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

    var identifier: UITableViewCell.Type {
        return TitleTableViewCell.self
    }

    func generate(tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.identifier.nameOfClass, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }

        self.build(view: cell)

        return cell
    }

}

// MARK: - ViewBuilder

extension TitleTableGenerator: ViewBuilder {

    func build(view: TitleTableViewCell) {
        view.fill(with: model)
    }
}
