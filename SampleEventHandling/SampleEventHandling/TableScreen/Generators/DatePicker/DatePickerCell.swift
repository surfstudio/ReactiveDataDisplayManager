//
//  DatePickerCell.swift
//  SampleEventHandling
//
//  Created by Alexander Kravchenkov on 01.08.17.
//  Copyright © 2017 Alexander Kravchenkov. All rights reserved.
//

import Foundation
import UIKit

class DatePickerCell: UITableViewCell {

    @IBOutlet fileprivate weak var picker: UIDatePicker!

    public var dateDidSet: BaseEvent<Date>?

    func configure(date: Date) {
        self.picker.setDate(date, animated: true)
    }

    @IBAction func actionDateChange(_ sender: Any) {
        self.dateDidSet?.invoke(with: self.picker.date)
    }
}
