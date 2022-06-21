//
//  CollectionDelegateStub.swift
//  ReactiveDataDisplayManager
//
//  Created by porohov on 21.06.2022.
//

import UIKit

@testable import ReactiveDataDisplayManager

final class CollectionDelegateStub: NSObject, CollectionDelegate {

    // MARK: - Testable Properties

    var builderConfigured = false

    // MARK: - CollectionDelegate Properties

    var manager: BaseCollectionManager?
    var collectionPlugins = PluginCollection<BaseCollectionPlugin<CollectionEvent>>()
    var scrollPlugins = PluginCollection<BaseCollectionPlugin<ScrollEvent>>()
    var movablePlugin: MovablePluginDelegate<CollectionGeneratorsProvider>?

    // MARK: - CollectionDelegate Methods

    func configure<T>(with builder: CollectionBuilder<T>) where T : BaseCollectionManager {
        builderConfigured = true
    }

}
