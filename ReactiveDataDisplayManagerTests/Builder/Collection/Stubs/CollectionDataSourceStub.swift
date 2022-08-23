//
//  CollectionDataSourceStub.swift
//  ReactiveDataDisplayManager
//
//  Created by porohov on 21.06.2022.
//

import UIKit

@testable import ReactiveDataDisplayManager

final class CollectionDataSourceStub: NSObject, CollectionDataSource {

    // MARK: - Testable Properties

    var builderConfigured = false
    var prefetchingItems = [IndexPath]()

    // MARK: - CollectionDataSource Properties

    var provider: CollectionSectionsProvider?
    var modifier: Modifier<UICollectionView, CollectionItemAnimation>?
    var prefetchPlugins = PluginCollection<BaseCollectionPlugin<PrefetchEvent>>()
    var collectionPlugins = PluginCollection<BaseCollectionPlugin<CollectionEvent>>()
    var itemTitleDisplayablePlugin: CollectionItemTitleDisplayable?
    var movablePlugin: MovablePluginDataSource<CollectionSectionsProvider>?

    // MARK: - CollectionDataSource Methods

    func configure<T>(with builder: CollectionBuilder<T>) where T: BaseCollectionManager {
        builderConfigured = true
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let provider = provider, provider.generators.indices.contains(section) else {
            return 0
        }
        return provider.generators[section].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        prefetchingItems = indexPaths
    }

}
