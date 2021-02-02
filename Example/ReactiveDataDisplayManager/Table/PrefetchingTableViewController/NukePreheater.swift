//
//  NukePreheater.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 29.01.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import Nuke
import ReactiveDataDisplayManager

final class NukePreheater: RddmPreheater {

    // MARK: - Private Properties

    private let imagePreheater = Nuke.ImagePreheater()

    // MARK: - Initialization

    init() {
        ImageLoadingOptions.shared.failureImage = #imageLiteral(resourceName: "imageNotFound")
    }

    // MARK: - RddmPreheater

    func startPrefetching(for requestId: [Any]) {
        guard let urls = requestId as? [URL] else { return }
        imagePreheater.startPreheating(with: urls)
    }

    func cancelPrefetching(for requestId: [Any]) {
        guard let urls = requestId as? [URL] else { return }
        imagePreheater.stopPreheating(with: urls)
    }

}
