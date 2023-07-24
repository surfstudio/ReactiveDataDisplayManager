//
//  TextStyle.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 14.06.2023.
//

import UIKit

public struct TextStyle: Equatable {

    public let color: UIColor
    public let font: UIFont

    public init(color: UIColor = .black, font: UIFont = .preferredFont(forTextStyle: .body)) {
        self.color = color
        self.font = font
    }

}
