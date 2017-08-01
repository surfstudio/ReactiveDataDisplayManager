//
//  TextWithLabelCell.swift
//  SampleEventHandling
//
//  Created by Alexander Kravchenkov on 01.08.17.
//  Copyright © 2017 Alexander Kravchenkov. All rights reserved.
//

import Foundation
import UIKit

class TextWithLabelCell: UITableViewCell {

    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var textField: UITextField!

    public weak var textFeildDelegate: UITextFieldDelegate? {
        didSet {
            self.textField.delegate = textFeildDelegate
        }
    }

    func configure(title: String, text: String?) {
        self.titleLabel.text = title
        self.textField.text = text
    }
}
