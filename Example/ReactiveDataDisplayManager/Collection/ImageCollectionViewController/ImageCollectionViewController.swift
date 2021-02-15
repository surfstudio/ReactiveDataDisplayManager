//
//  ImageCollectionViewController.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Vadim Tikhonov on 10.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager
import Nuke

final class ImageCollectionViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let cellSize = CGSize(width: 100, height: 100)
    }

    // MARK: - IBOutlet

    @IBOutlet private weak var collectionView: UICollectionView!

    // MARK: - Private Properties

    private lazy var adapter = collectionView.rddm.baseBuilder
        .build()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        DataLoader.sharedUrlCache.removeAllCachedResponses()
        ImageCache.shared.removeAll()

        title = "Gallery without prefetching"

        let flowLayout = makeFlowLayout()
        collectionView.setCollectionViewLayout(flowLayout, animated: false)

        fillAdapter()
    }

}

// MARK: - Private Methods

private extension ImageCollectionViewController {

    func makeFlowLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = Constants.cellSize
        flowLayout.minimumLineSpacing = 10.0
        flowLayout.minimumInteritemSpacing = 10.0
        flowLayout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        flowLayout.scrollDirection = .vertical

        return flowLayout
    }

    /// This method is used to fill adapter
    func fillAdapter() {
        for _ in 0...300 {
            // Create viewModels for cell
            guard let viewModel = ImageCollectionViewCell.ViewModel.make(for: Constants.cellSize) else { continue }

            // Create generator
            let generator = BaseCollectionCellGenerator<ImageCollectionViewCell>(with: viewModel)

            // Add generator to adapter
            adapter.addCellGenerator(generator)
        }

        // Tell adapter that we've changed generators
        adapter.forceRefill()
    }

}
