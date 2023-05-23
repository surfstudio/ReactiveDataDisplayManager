// 
//  ImageViewModel.swift
//  ReactiveDataDisplayManagerExample_iOS
//
//  Created by Olesya Tranina on 27.07.2021.
//

import UIKit

struct ImageViewModel {
    let imageUrl: URL
    let loadImage: (URL, UIImageView) -> Void

    static func make(with loadImage: @escaping (URL, UIImageView) -> Void) -> Self? {
        let stringImageUrl = "https://loremflickr.com/640/480/cat"
        guard let imageUrl = URL(string: stringImageUrl) else { return nil }
        return .init(imageUrl: imageUrl, loadImage: loadImage)
    }
}
