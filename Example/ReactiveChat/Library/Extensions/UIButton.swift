//
//  UIButton.swift
//  ReactiveDataDisplayManagerExample_iOS
//
//  Created by Никита Коробейников on 27.03.2023.
//

import UIKit

public extension UIButton {

    static var base: UIButton = {
        let button = UIButton(type: .roundedRect)
        return button
    }()

}
