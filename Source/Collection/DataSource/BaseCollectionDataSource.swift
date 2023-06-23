//
//  BaseCollectionDataSource.swift
//  ReactiveDataDisplayManager
//
//  Created by Vadim Tikhonov on 09.02.2021.
//  Copyright © 2021 Александр Кравченков. All rights reserved.
//

import UIKit

/// Base implementation for `UICollectionViewDataSource` protocol.
open class BaseCollectionDataSource: NSObject, CollectionDataSource {

    // MARK: - Typealias

    typealias CollectionAnimator = Animator<BaseCollectionManager.CollectionType>

    // MARK: - Properties

    public var modifier: Modifier<UICollectionView, CollectionItemAnimation>?
    public weak var provider: CollectionGeneratorsProvider?

    public var prefetchPlugins = PluginCollection<BaseCollectionPlugin<PrefetchEvent>>()
    public var collectionPlugins = PluginCollection<BaseCollectionPlugin<CollectionEvent>>()
    public var itemTitleDisplayablePlugin: CollectionItemTitleDisplayable?
    public var movablePlugin: MovablePluginDataSource<CollectionGeneratorsProvider>?

    // MARK: - Private Properties

    private var animator: CollectionAnimator?

}

// MARK: - CollectionBuilderConfigurable

extension BaseCollectionDataSource {

    public func configure<T>(with builder: CollectionBuilder<T>) where T: BaseCollectionManager {

        modifier = CollectionCommonModifier(view: builder.view, animator: builder.animator)

        animator = builder.animator
        movablePlugin = builder.movablePlugin?.dataSource
        collectionPlugins = builder.collectionPlugins
        itemTitleDisplayablePlugin = builder.itemTitleDisplayablePlugin

        if #available(iOS 10.0, tvOS 10.0, *) {
            prefetchPlugins = builder.prefetchPlugins
        }

        provider = builder.manager

        prefetchPlugins.setup(with: builder.manager)
        collectionPlugins.setup(with: builder.manager)

    }

}

// MARK: - UICollectionViewDataSource

extension BaseCollectionDataSource {

    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return provider?.sections.count ?? 0
    }

    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let provider = provider, provider.generators.indices.contains(section) else {
            return 0
        }
        return provider.generators[section].count
    }

    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let provider = provider else {
            return UICollectionViewCell()
        }
        let cell = provider
            .generators[indexPath.section][indexPath.row]
            .generate(collectionView: collectionView, for: indexPath)

        configureExpandableItem(for: cell, collectionView: collectionView)
        return cell
    }

    open func collectionView(_ collectionView: UICollectionView,
                             viewForSupplementaryElementOfKind kind: String,
                             at indexPath: IndexPath) -> UICollectionReusableView {
        guard let provider = provider else {
            return UICollectionReusableView()
        }

        switch kind {
        case UICollectionView.elementKindSectionHeader:
            return provider
                .sections[indexPath.section]
                .generate(collectionView: collectionView, for: indexPath)
        case UICollectionView.elementKindSectionFooter:
            return provider
                .footers[indexPath.section]
                .generate(collectionView: collectionView, for: indexPath)
        default:
            return UICollectionReusableView()
        }
    }

    open func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        movablePlugin?.moveRow(at: sourceIndexPath, to: destinationIndexPath, with: provider, and: collectionView, animator: animator)
        collectionPlugins.process(event: .move(from: sourceIndexPath, to: destinationIndexPath), with: provider as? BaseCollectionManager)
    }

    open func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return movablePlugin?.canMoveRow(at: indexPath, with: provider) ?? false
    }

    open func indexTitles(for collectionView: UICollectionView) -> [String]? {
        return itemTitleDisplayablePlugin?.indexTitles(with: provider)
    }

    open func collectionView(_ collectionView: UICollectionView, indexPathForIndexTitle title: String, at index: Int) -> IndexPath {
        return itemTitleDisplayablePlugin?.indexPathForIndexTitle(title, at: index, with: provider) ?? IndexPath()
    }

}

// MARK: - UICollectionViewDataSourcePrefetching

extension BaseCollectionDataSource {

    open func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        prefetchPlugins.process(event: .prefetch(indexPaths), with: provider as? BaseCollectionManager)
    }

    open func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        prefetchPlugins.process(event: .cancelPrefetching(indexPaths), with: provider as? BaseCollectionManager)
    }

}

// MARK: - ExpandableItem

private extension BaseCollectionDataSource {

    func configureExpandableItem(for cell: UICollectionViewCell, collectionView: UICollectionView) {
        guard let expandable = cell as? ExpandableItem else {
            return
        }
        expandable.onHeightChanged.addListner(with: "rddm.expandable-on-dequeue") { [weak self, weak expandable, weak collectionView] _ in
            guard let collectionView = collectionView,
                  let animated = expandable?.animatedExpandable else {
                return
            }

            self?.animator?.perform(in: collectionView,
                                    animated: animated,
                                    operation: nil)
        }
    }

}
