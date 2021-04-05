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

    private let imagePrefetcher: ImagePrefetcher

    // MARK: - Internal Properties

    let imageLoadingOptions: ImageLoadingOptions

    // MARK: - Initialization

    init(placeholder: UIImage) {
        DataLoader.sharedUrlCache.diskCapacity = 0

        let pipeline = ImagePipeline {
            let dataCache = try? DataCache(name: "ReactiveDataDisplayManagerExample.datacache")
            dataCache?.sizeLimit = 300 * 1024 * 1024
            $0.dataCache = dataCache
        }

        let tintOptions = ImageLoadingOptions.TintColors(success: .none,
                                failure: UIColor.gray.withAlphaComponent(0.2),
                                placeholder: .none)

        imagePrefetcher = ImagePrefetcher(pipeline: pipeline, destination: .diskCache, maxConcurrentRequestCount: 15)
        imageLoadingOptions = ImageLoadingOptions(placeholder: placeholder,
                                failureImage: placeholder.withRenderingMode(.alwaysTemplate),
                                contentModes: .init(success: .scaleAspectFill, failure: .scaleAspectFit, placeholder: .scaleAspectFit),
                                tintColors: tintOptions)
    }

    // MARK: - ContentPrefetcher

    func startPrefetching(for urls: [URL]) {
        imagePrefetcher.startPrefetching(with: urls)
    }

    func cancelPrefetching(for urls: [URL]) {
        imagePrefetcher.stopPrefetching(with: urls)
    }

}
