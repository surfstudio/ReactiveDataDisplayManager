//
//  UIViewController+Delay.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Никита Коробейников on 16.04.2021.
//

import Foundation
import UIKit

extension UIViewController {

    func delay(_ deadline: DispatchTime, completion: @escaping () -> Void) {
        DispatchQueue.global().asyncAfter(deadline: deadline) {
            DispatchQueue.main.async {
                completion()
            }
        }
    }

}
