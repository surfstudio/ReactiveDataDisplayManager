//
//  ImageUrlProvider.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 23.05.2023.
//

import Foundation
import UIKit

enum ImageUrlProvider {

    private static let allKeywords = ["cat", "dog", "man", "women", "tree", "money", "fun", "forest", "nature", "beach", "sun"]

    static func getRandomImage(of size: CGSize) -> String {
        let keyword = allKeywords.randomElement() ?? "cat"
        return "https://loremflickr.com/\(Int(size.width))/\(Int(size.height))/\(keyword)"
    }

}


