// 
//  TitleTableViewCell.swift
//  ReactiveDataDisplayManagerExample_tvOS
//
//  Created by Olesya Tranina on 26.07.2021.
//  
//

import ReactiveDataDisplayManager

final class TitleTableViewCell: UITableViewCell {

    // MARK: - IBOutlets

    @IBOutlet private weak var titleLabel: UILabel!

    // MARK: - UITableViewCells

    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.numberOfLines = 0
    }

}

// MARK: - ConfigurableItem

extension TitleTableViewCell: ConfigurableItem {

    func configure(with model: String) {
        titleLabel.text = model
    }

}
