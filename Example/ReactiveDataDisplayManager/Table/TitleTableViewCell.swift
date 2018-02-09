//
//  TitleTableViewCell.swift
//  ReactiveDataDisplayManager
//
//  Created by Ivan Smetanin on 19/12/2017.
//  Copyright © 2017 Alexander Kravchenkov. All rights reserved.
//

import UIKit

class TitleTableViewCell: UITableViewCell {

    // MARK: - IBOutlets

    @IBOutlet weak var titleLabel: UILabel!

    // MARK: - Internal methods

    func fill(with title: String) {
        titleLabel.text = title
    }
    
}
