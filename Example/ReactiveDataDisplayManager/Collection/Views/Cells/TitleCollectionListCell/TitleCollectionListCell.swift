//
//  TitleCollectionListCell.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Vadim Tikhonov on 09.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager

class TitleCollectionListCell: UICollectionViewCell, Configurable {

    // MARK: - IBOutlets

    @IBOutlet weak var titleLabel: UILabel!

    // MARK: - Configurable

    func configure(with title: String) {
        titleLabel.text = title
    }

}
