//
//  LabelGenerator.swift
//  SampleEventHandling
//
//  Created by Alexander Kravchenkov on 01.08.17.
//  Copyright © 2017 Alexander Kravchenkov. All rights reserved.
//

import Foundation
import UIKit

class LabelGenerator: SelectableItem {

    var didSelectEvent = BaseEvent<Void>()

    fileprivate weak var cell: LabelCell?

    fileprivate(set) var didSelected: Bool = false

    public var date: Date {
        didSet {
            self.cell?.configure(date: date)
        }
    }

    public init(date: Date) {
        self.date = date
    }
}

extension LabelGenerator: TableCellGenerator {

    var identifier: UITableViewCell.Type {
        return LabelCell.self
    }

    func generate(tableView: UITableView, forIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LabelCell.nameOfClass, for: indexPath)
        if let convertedCell = cell as? LabelCell {
            self.build(view: convertedCell)
        }
        cell.selectionStyle = .none
        cell.contentView.layoutMargins = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 20)
        return cell
    }
}

extension LabelGenerator: ViewBuilder {

    func build(view: LabelCell) {
        self.cell = view
        view.configure(date: self.date)
        self.didSelectEvent += {
            self.didSelected = !self.didSelected
        }
    }
}
