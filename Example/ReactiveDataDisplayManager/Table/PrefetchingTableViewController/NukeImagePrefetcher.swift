//
//  NukeImagePrefetcher.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 29.01.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import Nuke
import ReactiveDataDisplayManager

final class NukeImagePrefetcher: ContentPrefetcher {

    // MARK: - Private Properties

    private let imagePreheater = Nuke.ImagePreheater()

    // MARK: - Initialization

    init() {
        ImageLoadingOptions.shared.failureImage = #imageLiteral(resourceName: "imageNotFound")
    }

    // MARK: - ContentPrefetcher

    func startPrefetching(for urls: [URL]) {
        imagePreheater.startPreheating(with: urls)
    }

    func cancelPrefetching(for urls: [URL]) {
        imagePreheater.stopPreheating(with: urls)
    }

}
