//
//  HeaderCollectionListView.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Vadim Tikhonov on 09.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager

final class HeaderCollectionListView: UICollectionReusableView, AccessibilityItem {

    // MARK: - IBOutlets

    @IBOutlet private weak var titleLabel: UILabel!

    // MARK: - AccessibilityItem

    var labelStrategy: AccessibilityStrategy { .from(titleLabel) }
    var traitsStrategy: AccessibilityTraitsStrategy { .from(titleLabel) }

    // MARK: - Internal Methods

    func fill(title: String) {
        self.titleLabel.text = title
    }

}
