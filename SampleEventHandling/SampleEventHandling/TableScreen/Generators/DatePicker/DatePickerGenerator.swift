//
//  DatePickerGenerator.swift
//  SampleEventHandling
//
//  Created by Alexander Kravchenkov on 01.08.17.
//  Copyright © 2017 Alexander Kravchenkov. All rights reserved.
//

import Foundation
import UIKit

class DatePickerGenerator {
    var valueChanged = BaseEvent<Date>()

    fileprivate let date: Date

    init(date: Date) {
        self.date = date
    }
}

extension DatePickerGenerator: TableCellGenerator {

    var identifier: UITableViewCell.Type {
        return DatePickerCell.self
    }

    func generate(tableView: UITableView, forIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DatePickerCell.nameOfClass, for: indexPath)
        if let convertedCell = cell as? DatePickerCell {
            self.build(view: convertedCell)
        }
        cell.selectionStyle = .none
        cell.contentView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 20)
        return cell
    }
}

extension DatePickerGenerator: ViewBuilder {

    func build(view: DatePickerCell) {
        view.configure(date: self.date)
        view.dateDidSet = valueChanged
    }
}
