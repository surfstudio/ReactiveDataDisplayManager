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

    private let imagePreheater: ImagePreheater

    // MARK: - Initialization

    init(placeholder: UIImage) {
        DataLoader.sharedUrlCache.diskCapacity = 0

        let pipeline = ImagePipeline {
            let dataCache = try? DataCache(name: "ReactiveDataDisplayManagerExample.datacache")
            dataCache?.sizeLimit = 300 * 1024 * 1024
            $0.dataCache = dataCache
        }

        ImagePipeline.shared = pipeline
        ImageLoadingOptions.shared.placeholder = placeholder
        ImageLoadingOptions.shared.failureImage = placeholder.withRenderingMode(.alwaysTemplate)
        ImageLoadingOptions.shared.tintColors = .init(success: .none,
                                                      failure: UIColor.gray.withAlphaComponent(0.2),
                                                      placeholder: .none)
        imagePreheater = Nuke.ImagePreheater(maxConcurrentRequestCount: 15)
    }

    // MARK: - ContentPrefetcher

    func startPrefetching(for urls: [URL]) {
        imagePreheater.startPreheating(with: urls)
    }

    func cancelPrefetching(for urls: [URL]) {
        imagePreheater.stopPreheating(with: urls)
    }

}
