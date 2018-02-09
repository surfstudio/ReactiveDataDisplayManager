//
//  TitleCollectionViewCell.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Ivan Smetanin on 27/01/2018.
//  Copyright © 2018 Alexander Kravchenkov. All rights reserved.
//

import UIKit

class TitleCollectionViewCell: UICollectionViewCell {

    // MARK: - IBOutlets

    @IBOutlet weak var titleLabel: UILabel!

    // MARK: - Internal methods

    func fill(with title: String) {
        titleLabel.text = title
    }

}
