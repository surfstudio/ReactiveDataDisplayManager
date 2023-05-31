//
//  LayoutType.swift
//  ReactiveChat_iOS
//
//  Created by Никита Коробейников on 29.05.2023.
//

import Foundation

enum LayoutType: String, CaseIterable, CustomStringConvertible {

    case table
    case collection

    var description: String {
        rawValue.capitalized
    }

}
