//
//  PrefetcherStub.swift
//  ReactiveDataDisplayManager
//
//  Created by porohov on 21.06.2022.
//

import UIKit

@testable import ReactiveDataDisplayManager

final class PrefetcherStub: ContentPrefetcher {

    // MARK: - Testable Properties

    var isPrefetchingItems = [Bool]()

    // MARK: - ContentPrefetcher

    func startPrefetching(for isPrefetching: [Bool]) {
        isPrefetchingItems = isPrefetching
    }

    func cancelPrefetching(for isPrefetching: [Bool]) {
        isPrefetchingItems = isPrefetching
    }

}
