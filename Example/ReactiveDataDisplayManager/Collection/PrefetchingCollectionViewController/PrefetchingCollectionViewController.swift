//
//  PrefetchingCollectionViewController.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 12.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager
import Nuke

final class PrefetchingCollectionViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let insets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        static let minimumSpacing: CGFloat = 10
        static let cellWidth = (UIScreen.main.bounds.width - (insets.left + insets.right + minimumSpacing)) / 2
        static let cellSize = CGSize(width: cellWidth, height: 240)
    }

    // MARK: - IBOutlet

    @IBOutlet private weak var collectionView: UICollectionView!

    // MARK: - Private Properties

    private let prefetcher = NukeImagePrefetcher()
    private lazy var prefetcherablePlugin: CollectionPrefetcherablePlugin<NukeImagePrefetcher, ImageCollectionCellGenerator> = .prefetch(prefetcher: prefetcher)

    private lazy var adapter = collectionView.rddm.baseBuilder
        .add(plugin: prefetcherablePlugin)
        .build()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        DataLoader.sharedUrlCache.removeAllCachedResponses()
        ImageCache.shared.removeAll()
        if let dataCache = ImagePipeline.shared.configuration.dataCache as? DataCache {
            dataCache.removeAll()
        }

        title = "Gallery with prefetching"

        let flowLayout = makeFlowLayout()
        collectionView.setCollectionViewLayout(flowLayout, animated: false)

        fillAdapter()
    }

}

// MARK: - Private Methods

private extension PrefetchingCollectionViewController {

    func makeFlowLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = Constants.cellSize
        flowLayout.minimumLineSpacing = Constants.minimumSpacing
        flowLayout.minimumInteritemSpacing = Constants.minimumSpacing
        flowLayout.sectionInset = Constants.insets
        flowLayout.scrollDirection = .vertical

        return flowLayout
    }

    /// This method is used to fill adapter
    func fillAdapter() {
        for _ in 0...300 {
            // Create viewModels for cell
            guard let viewModel = ImageCollectionViewCell.ViewModel.make() else { continue }

            // Create generator
            let generator = ImageCollectionViewCell.rddm.baseGenerator(with: viewModel)

            // Add generator to adapter
            adapter.addCellGenerator(generator)
        }

        // Tell adapter that we've changed generators
        adapter.forceRefill()
    }

}

