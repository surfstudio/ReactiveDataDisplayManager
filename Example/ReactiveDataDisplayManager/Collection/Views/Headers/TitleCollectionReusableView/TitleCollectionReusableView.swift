//
//  TitleCollectionReusableView.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Dryakhlykh on 25.11.2019.
//  Copyright © 2019 Alexander Kravchenkov. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager

final class TitleCollectionReusableView: UICollectionReusableView, AccessibilityItem {

    // MARK: - IBOutlets

    @IBOutlet private weak var titleLabel: UILabel!

    // MARK: - AccessibilityItem

    var labelStrategy: AccessibilityStringStrategy { .from(object: titleLabel) }
    var traitsStrategy: AccessibilityTraitsStrategy { .from(object: titleLabel) }

    // MARK: - Internal methods

    func fill(title: String) {
        self.titleLabel.text = title
    }

}
