//
//  UILabel.swift
//  ReactiveDataDisplayManagerExample_iOS
//
//  Created by Никита Коробейников on 27.03.2023.
//

import UIKit

public extension UILabel {

    static var base: UILabel {
        let label = UILabel()
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }

}
