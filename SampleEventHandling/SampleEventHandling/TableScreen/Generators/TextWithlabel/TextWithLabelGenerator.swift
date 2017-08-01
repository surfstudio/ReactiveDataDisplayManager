//
//  TextWithLabelGenerator.swift
//  SampleEventHandling
//
//  Created by Alexander Kravchenkov on 01.08.17.
//  Copyright © 2017 Alexander Kravchenkov. All rights reserved.
//

import Foundation
import UIKit

class TextWithLabelGenerator: NSObject {

    fileprivate let model: String
    fileprivate let text: String?

    public var textShouldChange: BaseValueEvent<String, Bool>

    init(model: String, text: String?) {
        self.model = model
        self.text = text
        self.textShouldChange = BaseValueEvent()
    }
}

extension TextWithLabelGenerator: TableCellGenerator {

    var identifier: UITableViewCell.Type {
        return TextWithLabelCell.self
    }

    func generate(tableView: UITableView, forIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TextWithLabelCell.nameOfClass, for: indexPath)
        if let convertedCell = cell as? TextWithLabelCell {
            self.build(view: convertedCell)
        }
        cell.selectionStyle = .none
        cell.contentView.layoutMargins = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 20)
        return cell
    }
}

extension TextWithLabelGenerator: ViewBuilder {

    func build(view: TextWithLabelCell) {
        view.configure(title: self.model, text: self.text)
        view.textFeildDelegate = self
    }
}

extension TextWithLabelGenerator: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let resultString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        return self.textShouldChange.valueListner?(resultString) ?? true
    }
}
