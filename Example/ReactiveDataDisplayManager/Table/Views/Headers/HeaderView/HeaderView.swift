//
//  HeaderView.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 02.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager

extension UIView {

    func fromNib() -> Self? {
        let bundleName = Bundle(for: type(of: self))
        let nibName = String(describing: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundleName)
        return nib.instantiate(withOwner: nil, options: nil).first as? Self
    }

}

final class HeaderView: UIView, AccessibilityItem {

    // MARK: - IBOutlet

    @IBOutlet private weak var titleLabel: UILabel!

    // MARK: - AccessibilityItem

    var labelStrategy: AccessibilityStringStrategy { .from(object: titleLabel) }
    var traitsStrategy: AccessibilityTraitsStrategy { .from(object: titleLabel) }

    // MARK: - Internal Methods

    func configure(with title: String) {
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
    }

}
