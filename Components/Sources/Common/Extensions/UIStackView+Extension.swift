//
//  UIStackView+Extension.swift
//  ReactiveDataDisplayManager
//
//  Created by Konstantin Porokhov on 29.06.2023.
//

import UIKit

// MARK: - Support

extension UIStackView {

    func removeAllArrangedSubviews() {
        arrangedSubviews.forEach { view in
            removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }

}
