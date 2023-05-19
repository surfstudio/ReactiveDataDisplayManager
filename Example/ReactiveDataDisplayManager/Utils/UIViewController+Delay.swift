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

    func scheduleIfNeeded(closure: @escaping () -> Void) {
    #if DEBUG
        if CommandLine.arguments.contains("-stress") {
            delay(.now() + .milliseconds(500) + .milliseconds(10), completion: closure)
            delay(.now() + .milliseconds(500) + .milliseconds(50), completion: closure)
            delay(.now() + .milliseconds(500) + .milliseconds(100), completion: closure)
            delay(.now() + .milliseconds(500) + .milliseconds(150), completion: closure)
            delay(.now() + .milliseconds(500) + .milliseconds(200), completion: closure)
            delay(.now() + .seconds(1) + .milliseconds(10), completion: closure)
            delay(.now() + .seconds(1) + .milliseconds(50), completion: closure)
            delay(.now() + .seconds(1) + .milliseconds(100), completion: closure)
            delay(.now() + .seconds(1) + .milliseconds(150), completion: closure)
            delay(.now() + .seconds(1) + .milliseconds(200), completion: closure)
        }
    #endif
    }

}
