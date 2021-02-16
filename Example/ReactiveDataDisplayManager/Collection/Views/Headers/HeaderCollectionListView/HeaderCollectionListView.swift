//
//  HeaderCollectionListView.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Vadim Tikhonov on 09.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import UIKit

final class HeaderCollectionListView: UICollectionReusableView {

    // MARK: - IBOutlets

    @IBOutlet weak var titleLabel: UILabel!

    // MARK: - Internal Methods

    func fill(title: String) {
        self.titleLabel.text = title
    }
    
}
