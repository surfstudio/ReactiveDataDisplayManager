//
//  ImageUrlProvider.swift
//  ReactiveDataDisplayManagerExample_tvOS
//
//  Created by Никита Коробейников on 24.05.2023.
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
