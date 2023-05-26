//
//  UIViewController.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 10.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import UIKit

extension UIViewController {

    func showAlert(_ message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }

    func showSheet<Item: CustomStringConvertible>(title: String,
                                                  items: [Item],
                                                  completion: @escaping (Item) -> Void) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)

        items.map { item in
            UIAlertAction(title: item.description, style: .default) { _ in
                completion(item)
            }
        }.forEach { alert.addAction($0) }

        present(alert, animated: true, completion: nil)
    }

}
