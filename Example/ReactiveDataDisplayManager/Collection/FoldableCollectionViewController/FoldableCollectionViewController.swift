//
//  FoldableCollectionViewController.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Vadim Tikhonov on 11.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager
import Nuke

final class FoldableCollectionViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let cellSize = CGSize(width: 100, height: 100)
    }

    // MARK: - IBOutlet

    @IBOutlet private weak var collectionView: UICollectionView!

    // MARK: - Private Properties

    private lazy var adapter = collectionView.rddm.manualBuilder
        .add(plugin: CollectionFoldablePlugin())
        .build()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Foldable collection"

        let flowLayout = makeFlowLayout()
        collectionView.setCollectionViewLayout(flowLayout, animated: false)

        fillAdapter()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        DataLoader.sharedUrlCache.removeAllCachedResponses()
        ImageCache.shared.removeAll()
    }

}

// MARK: - Private Methods

private extension FoldableCollectionViewController {

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
        // Add regular cell generators with titles
        adapter.addCellGenerators(makeRegularCellWithTitlesGenerators(count: 3))

        // Add foldable cell generator to adapter
        adapter.addCellGenerator(makeFoldableCellGenerator())

        // Add regular cell generators with titles
        adapter.addCellGenerators(makeRegularCellWithTitlesGenerators(count: 3))

        // Add foldable cell generator to adapter
        adapter.addCellGenerator(makeFoldableCellGenerator())

        // Tell adapter that we've changed generators
        adapter.forceRefill()
    }

    func makeRegularCellWithTitlesGenerators(count: Int) -> [CollectionCellGenerator] {
        let endIndex = count - 1

        guard endIndex > 1 else {
            return []
        }

        var generators = [CollectionCellGenerator]()

        for _ in 0...endIndex {
            guard let viewModel = ImageCollectionViewCell.ViewModel.make() else { continue }
            let generator = BaseCollectionCellGenerator<ImageCollectionViewCell>(with: viewModel)
            generators.append(generator)
        }

        return generators
    }

    func makeFoldableCellGenerator() -> FoldableCollectionCellGenerator {
        // Create foldable generator
        let generator = FoldableCollectionCellGenerator()

        // Create and add child generators
        generator.childGenerators = makeRegularCellWithTitlesGenerators(count: 3)

        return generator
    }


}
