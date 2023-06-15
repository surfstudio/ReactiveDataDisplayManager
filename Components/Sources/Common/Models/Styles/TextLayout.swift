//
//  TextLayout.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 14.06.2023.
//

import UIKit

public struct TextLayout: Equatable {

    public let lineBreakMode: NSLineBreakMode
    public let numberOfLines: Int

    public init(lineBreakMode: NSLineBreakMode = .byWordWrapping, numberOfLines: Int = 0) {
        self.lineBreakMode = lineBreakMode
        self.numberOfLines = numberOfLines
    }

}
