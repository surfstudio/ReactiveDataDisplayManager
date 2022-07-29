//
//  SpyCollectionPrefetchProxyPlugin.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 29.07.2022.
//

@testable import ReactiveDataDisplayManager

final class SpyCollectionPrefetchProxyPlugin: CollectionPrefetchProxyPlugin {

    private(set) var prefetchEventWasCalled = false
    private(set) var cancelPrefetchingEventWasCalled = false

    override init() {
        super.init()
        setupEvents()
    }

    private func setupEvents() {
        prefetchEvent += { [weak self] _ in
            self?.prefetchEventWasCalled = true
        }
        cancelPrefetchingEvent += { [weak self] _ in
            self?.cancelPrefetchingEventWasCalled = true
        }
    }

}
