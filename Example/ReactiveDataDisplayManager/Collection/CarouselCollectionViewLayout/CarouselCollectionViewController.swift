//
//  CarouselCollectionViewViewController.swift
//  ReactiveDataDisplayManagerExample_iOS
//
//  Created by porohov on 15.11.2021.
//

import UIKit
import ReactiveDataDisplayManager
import Nuke

final class CarouselCollectionViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let size = CGSize(width: 150, height: 150)
        static let padding: CGFloat = 5
        static let insets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }

    // MARK: - IBOutlets

    @IBOutlet private weak var collectionView: UICollectionView!

    // MARK: - Private Properties

    private lazy var adapter = collectionView.rddm.baseBuilder
        .add(plugin: .accessibility())
        .build()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        fillAdapter()
        configureLayoutFlow()
    }

}

// MARK: - Private Methods

private extension CarouselCollectionViewController {

    func fillAdapter() {
        for _ in 0...30 {
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

    func configureLayoutFlow() {
        let layout = CarouselCollectionViewLayout()
        layout.setCells(
            size: Constants.size,
            padding: Constants.padding,
            insets: Constants.insets
        )
        collectionView.setCollectionViewLayout(layout, animated: true)
    }

    /// This method load image and set to UIImageView
    func loadImage(url: URL, imageView: UIImageView) {
        Nuke.loadImage(with: url, into: imageView)
    }

}
