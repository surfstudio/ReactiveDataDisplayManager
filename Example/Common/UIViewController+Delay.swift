//
//  UIViewController+Delay.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Никита Коробейников on 16.04.2021.
//

import Foundation
import UIKit

extension UIResponder {

    func delay(_ deadline: DispatchTime, completion: @escaping () -> Void) {
        let normalizedDeadline: DispatchTime

        if CommandLine.arguments.contains("-decreaseDelay") {
            // to improve UI tests performance we are using one delay for any values
            normalizedDeadline = .now() + .nanoseconds(100)
        } else {
            normalizedDeadline = deadline
        }
        DispatchQueue.global(qos: .utility).asyncAfter(deadline: normalizedDeadline) {
            DispatchQueue.main.async {
                completion()
            }
        }
    }

    func scheduleIfNeeded(closure: @escaping () -> Void) {
    #if DEBUG
        if CommandLine.arguments.contains("-stress") {
            delay(.now() + .milliseconds(500) + .milliseconds(10), completion: closure)
            delay(.now() + .milliseconds(500) + .milliseconds(300), completion: closure)
            delay(.now() + .seconds(1) + .milliseconds(200), completion: closure)
            delay(.now() + .seconds(1) + .milliseconds(800), completion: closure)
            delay(.now() + .seconds(2) + .milliseconds(200), completion: closure)
            delay(.now() + .seconds(2) + .milliseconds(500), completion: closure)
            delay(.now() + .seconds(3) + .milliseconds(100), completion: closure)
            delay(.now() + .seconds(4) + .milliseconds(600), completion: closure)
            delay(.now() + .seconds(5) + .milliseconds(400), completion: closure)
            delay(.now() + .seconds(5) + .milliseconds(700), completion: closure)
        }
    #endif
    }

}
