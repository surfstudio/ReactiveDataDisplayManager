//
//  LabelCell.swift
//  SampleEventHandling
//
//  Created by Alexander Kravchenkov on 01.08.17.
//  Copyright © 2017 Alexander Kravchenkov. All rights reserved.
//

import Foundation
import UIKit

class LabelCell: UITableViewCell {

    @IBOutlet fileprivate weak var label: UILabel!

    func configure(date: Date) {
        let components = Calendar.current.dateComponents([.day, .month, .year], from: date)
        guard let day = components.day, let month = components.month, let year = components.year else { return }

        self.label.text = "Дата рождения: \(day).\(month).\(year)"
    }
}
