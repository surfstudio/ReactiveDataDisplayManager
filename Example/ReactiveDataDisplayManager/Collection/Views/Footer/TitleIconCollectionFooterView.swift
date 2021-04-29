//
//  TitleCollectionFooterView.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Dmitry Korolev on 05.04.2021.
//

import UIKit

class TitleIconCollectionFooterView: UICollectionReusableView {

    // MARK: - IBOutlets

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!

    // MARK: - Internal methods

    func fill(title: String) {
        self.titleLabel.text = title
        self.iconImageView.image = #imageLiteral(resourceName: "ReactiveIconHorizontal")
    }

}
