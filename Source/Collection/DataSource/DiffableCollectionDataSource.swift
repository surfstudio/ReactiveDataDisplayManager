//
//  DiffableCollectionDataSource.swift
//  ReactiveDataDisplayManager
//
//  Created by Никита Коробейников on 15.03.2021.
//

import UIKit

/// DataSource based on `UICollectionViewDiffableDataSource` with automatic cells managing
///
/// - Warning: Required to conform all generators to `DiffableItemSource`
@available(iOS 13.0, *)
open class DiffableCollectionDataSource: UICollectionViewDiffableDataSource<DiffableItem, DiffableItem>, CollectionDataSource {

    // MARK: - Properties

    weak public var provider: CollectionGeneratorsProvider?

    public var modifier: Modifier<UICollectionView, CollectionItemAnimation>?

    public var prefetchPlugins = PluginCollection<BaseCollectionPlugin<PrefetchEvent>>()
    public var collectionPlugins = PluginCollection<BaseCollectionPlugin<CollectionEvent>>()
    public var itemTitleDisplayablePlugin: CollectionItemTitleDisplayable?

    // MARK: - Initialization

    /// - parameter provider: provider of `UICollectionView` and `UICollectionViewCells`
    public init(provider: BaseCollectionManager) {

        super.init(collectionView: provider.view) { (collection, indexPath, item) -> UICollectionViewCell? in
            provider
                .generators[indexPath.section][indexPath.row]
                .generate(collectionView: collection, for: indexPath)
        }

        self.provider = provider
    }

    // MARK: - CollectionBuilderConfigurable

    public func configure<T>(with builder: CollectionBuilder<T>) where T : BaseCollectionManager {

        modifier = CollectionDiffableModifier(view: builder.view, provider: builder.manager, dataSource: self)

        collectionPlugins = builder.collectionPlugins
        itemTitleDisplayablePlugin = builder.itemTitleDisplayablePlugin

        prefetchPlugins = builder.prefetchPlugins

        provider = builder.manager

        prefetchPlugins.setup(with: builder.manager)
        collectionPlugins.setup(with: builder.manager)

    }

}

// MARK: - UITableViewDataSourcePrefetching

@available(iOS 13.0, *)
extension DiffableCollectionDataSource {

    open func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        prefetchPlugins.process(event: .prefetch(indexPaths), with: provider as? BaseCollectionManager)
    }

    open func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        prefetchPlugins.process(event: .cancelPrefetching(indexPaths), with: provider as? BaseCollectionManager)
    }

}
