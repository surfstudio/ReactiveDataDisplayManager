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

    @IBOutlet private weak var titleLabel: UILabel!

    // MARK: - Internal methods

    func fill(title: String) {
        self.titleLabel.text = title
    }

}
