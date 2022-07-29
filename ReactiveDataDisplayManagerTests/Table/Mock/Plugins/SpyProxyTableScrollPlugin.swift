//
//  SpyProxyTableScrollPlugin.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 29.07.2022.
//

@testable import ReactiveDataDisplayManager

final class SpyProxyTableScrollPlugin: TableScrollViewDelegateProxyPlugin {

    var didScrollWasCalled = false
    var didEndScrollingAnimationWasCalled = false

    override init() {
        super.init()
        setupEvents()
    }

    private func setupEvents() {
        didScroll += { [weak self] _ in
            self?.didScrollWasCalled = true
        }
        didEndScrollingAnimation += { [weak self] _ in
            self?.didEndScrollingAnimationWasCalled = true
        }
    }

}
