//
//  TitleCollectionReusableView.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Dryakhlykh on 25.11.2019.
//  Copyright © 2019 Alexander Kravchenkov. All rights reserved.
//

import UIKit

final class TitleCollectionReusableView: UICollectionReusableView {

    // MARK: - IBOutlets

    @IBOutlet weak var titleLabel: UILabel!

    // MARK: - Public Methods

    func fill(title: String) {
        self.titleLabel.text = title
    }
}
