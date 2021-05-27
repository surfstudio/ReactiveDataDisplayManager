//
//  ImageHorizontalCollectionViewController.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 14.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import UIKit
import SurfUtils
import ReactiveDataDisplayManager
import Nuke

extension ItemsScrollManager: CollectionScrollProvider {}

final class ImageHorizontalCollectionViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let cellSize = CGSize(width: 120, height: 120)
        static let sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
        static let horizontalItemSpace: CGFloat = 20
    }

    // MARK: - IBOutlet

    @IBOutlet private weak var collectionView: UICollectionView!

    // MARK: - Private Properties

    private let scrollManager = ItemsScrollManager(cellWidth: Constants.cellSize.width,
                                                   cellOffset: Constants.horizontalItemSpace,
                                                   insets: Constants.sectionInset)

    private lazy var adapter = collectionView.rddm.baseBuilder
        .add(plugin: .scrollableBehaviour(scrollProvider: scrollManager))
        .add(plugin: .scrollOnSelect(to: .centeredHorizontally))
        .build()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Horizontal image collection"

        configureCollectionView()

        fillAdapter()
    }

}

// MARK: - Private Methods

private extension ImageHorizontalCollectionViewController {

    func configureCollectionView() {
        collectionView.decelerationRate = .fast
        collectionView.showsHorizontalScrollIndicator = false

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = Constants.cellSize
        layout.sectionInset = Constants.sectionInset
        layout.minimumLineSpacing = Constants.horizontalItemSpace
        layout.minimumInteritemSpacing = 0
        collectionView.setCollectionViewLayout(layout, animated: false)
    }

    /// This method is used to fill adapter
    func fillAdapter() {
        for _ in 0...300 {
            // Create viewModels for cell
            guard let viewModel = ImageCollectionViewCell.ViewModel.make(with: loadImage) else { continue }

            // Create generator
            let generator = ImageCollectionViewCell.rddm.baseGenerator(with: viewModel)

            // Add generator to adapter
            adapter.addCellGenerator(generator)
        }

        // Tell adapter that we've changed generators
        adapter.forceRefill()
    }

    /// This method load image and set to UIImageView
    func loadImage(url: URL, imageView: UIImageView) {
        Nuke.loadImage(with: url, into: imageView)
    }

}
