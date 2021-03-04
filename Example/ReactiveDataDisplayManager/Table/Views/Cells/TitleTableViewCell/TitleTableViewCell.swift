//
//  TitleTableViewCell.swift
//  ReactiveDataDisplayManager
//
//  Created by Ivan Smetanin on 19/12/2017.
//  Copyright © 2017 Alexander Kravchenkov. All rights reserved.
//

import ReactiveDataDisplayManager

class TitleTableViewCell: UITableViewCell, CalculatableHeightItem {

    // MARK: - IBOutlets

    @IBOutlet weak var titleLabel: UILabel!

    // MARK: - Internal methods

    func fill(with title: String) {
        titleLabel.text = title
    }

    static func getHeight(forWidth width: CGFloat, with model: String) -> CGFloat {
        return 44
    }
    
}

extension TitleTableViewCell: ConfigurableItem {

    func configure(with model: String) {
        titleLabel.text = model
    }

}
