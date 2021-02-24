//
//  Appearance.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 24.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import UIKit

enum Appearance {
    case grid
    case table(width: CGFloat)

    var cellSize: CGSize {
        switch self {
        case .grid:
            return CGSize(width: 100, height: 100)
        case .table(let width):
            return CGSize(width: width, height: 50)
        }
    }

    var title: String {
        switch self {
        case .grid:
            return "Grid"
        case .table:
            return "Table"
        }
    }
}
