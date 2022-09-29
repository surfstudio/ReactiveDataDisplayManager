//
//  NSLayoutConstraints+Shortcuts.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 23.09.2022.
//

import UIKit

extension UIView {

    func wrap(subview: UIView, with insets: UIEdgeInsets) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
        NSLayoutConstraint.activate([
            subview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left),
            subview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.right),
            subview.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
            subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom)
        ])
    }

}
