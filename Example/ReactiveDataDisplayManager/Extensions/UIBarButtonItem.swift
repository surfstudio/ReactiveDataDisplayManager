//
//  UIBarButtonItem.swift
//  ReactiveDataDisplayManagerExample_iOS
//
//  Created by Artem Kayumov on 19.05.2022.
//

import UIKit

public extension UIBarButtonItem {

    static var empty: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
//        button.accessibilityIdentifier = ""
        return button
    }()

}
