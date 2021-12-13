//
//  Array.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 14.04.2021.
//

import ReactiveDataDisplayManager

extension Array {

    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }

}
