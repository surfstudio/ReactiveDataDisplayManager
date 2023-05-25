//
//  NavigationController.swift
//  ReactiveDataDisplayManagerExample_iOS
//
//  Created by Artem Kayumov on 19.05.2022.
//

import UIKit

class NavigationController: UINavigationController {

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }

}

// MARK: - UINavigationControllerDelegate

extension NavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        viewController.navigationItem.backBarButtonItem = .empty
    }
}
