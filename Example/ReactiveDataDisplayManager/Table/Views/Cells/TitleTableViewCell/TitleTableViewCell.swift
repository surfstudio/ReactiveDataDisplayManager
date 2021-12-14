//
//  TitleTableViewCell.swift
//  ReactiveDataDisplayManager
//
//  Created by Ivan Smetanin on 19/12/2017.
//  Copyright © 2017 Alexander Kravchenkov. All rights reserved.
//

import ReactiveDataDisplayManager
import UIKit

class TitleTableViewCell: UITableViewCell {

    // MARK: - IBOutlets

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var titleLabelTopOffset: NSLayoutConstraint!
    
    // MARK: - Internal methods

    func fill(with title: String) {
        titleLabel.text = title
    }

}

// MARK: - ConfigurableItem

extension TitleTableViewCell: ConfigurableItem {

    func configure(with model: String) {
        titleLabel.text = model
    }

    func setOffset(top: CGFloat) {
        titleLabelTopOffset.constant = top
    }

}
