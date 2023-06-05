//
//  TitleCollectionReusableView.swift
//  ReactiveDataDisplayManagerExample_tvOS
//
//  Created by Никита Коробейников on 09.06.2021.
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
