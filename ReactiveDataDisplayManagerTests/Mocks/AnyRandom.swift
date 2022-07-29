//
//  AnyRandom.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 29.07.2022.
//

import Foundation
import UIKit

extension CGFloat {

    static func anyRandom() -> CGFloat {
        CGFloat.random(in: 0...CGFloat.greatestFiniteMagnitude)
    }

}

extension Double {

    static func anyRandom() -> Double {
        Double.random(in: 0...Double.greatestFiniteMagnitude)
    }

}

extension Int {

    static func anyRandom() -> Int {
        Int.random(in: 0...Int.max)
    }

}
