//
//  TitleWithIconTableViewCell.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Dmitry Korolev on 30.03.2021.
//

import ReactiveDataDisplayManager

class TitleWithIconTableViewCell: UITableViewCell, CalculatableHeightItem {

    // MARK: - IBOutlets

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!

    // MARK: - Internal methods

    func fill(with title: String) {
        titleLabel.text = title
    }

    static func getHeight(forWidth width: CGFloat, with model: String) -> CGFloat {
        return 44
    }
    
}

extension TitleWithIconTableViewCell: ConfigurableItem {

    func configure(with model: String) {
        accessoryType = .disclosureIndicator
        titleLabel.text = model
        iconImageView.image = #imageLiteral(resourceName: "ReactiveIconHorizontal")
    }

}

