//
//  UIView+Extension.swift
//  ReactiveDataDisplayManager
//
//  Created by Konstantin Porokhov on 29.06.2023.
//

import UIKit

extension UIView {

    @discardableResult
    func updateFrameByContent() -> UIView {
        let newSize = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        frame.size = newSize

        return self
    }

    func attach(to view: UIView,
                topOffset: CGFloat = 0,
                bottomOffset: CGFloat = 0,
                leftOffset: CGFloat = 0,
                rightOffset: CGFloat = 0) {
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor, constant: topOffset),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -bottomOffset),
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftOffset),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -rightOffset)
        ])
    }

    static func loadFromNib<T: UIView>(bundle: Bundle) -> T {
        let nibName = String(describing: self)
        let nib = UINib(nibName: nibName, bundle: bundle)

        guard let view = nib.instantiate(withOwner: self, options: nil).first as? T else {
            return T()
        }

        return view
    }

}
