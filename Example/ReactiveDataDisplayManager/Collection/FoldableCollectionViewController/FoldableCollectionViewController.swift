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

// MARK: - Appearance

private enum Appearance {
    case grid
    case table(width: CGFloat)

    var cellSize: CGSize {
        switch self {
        case .grid:
            return CGSize(width: 100, height: 100)
        case .table(let width):
            return CGSize(width: width, height: 50)
        }
    }

    var title: String {
        switch self {
        case .grid:
            return "Grid"
        case .table:
            return "Table"
        }
    }
}

final class FoldableCollectionViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }

    // MARK: - IBOutlet

    @IBOutlet private weak var collectionView: UICollectionView!

    // MARK: - Private Properties

    private lazy var adapter = collectionView.rddm.flowBuilder
        .add(plugin: CollectionFoldablePlugin())
        .build()

    private var appearance: Appearance = .grid

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Foldable collection"

        configureLayoutFlow(with: appearance)
        updateBarButtonItem(with: appearance.title)

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

    func configureLayoutFlow(with appearance: Appearance) {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = appearance.cellSize
        flowLayout.minimumLineSpacing = 10.0
        flowLayout.minimumInteritemSpacing = 10.0
        flowLayout.sectionInset = Constants.sectionInset
        flowLayout.scrollDirection = .vertical

        collectionView.setCollectionViewLayout(flowLayout, animated: true)
    }

    func updateBarButtonItem(with title: String) {
        let button = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(changeListAppearance))
        navigationItem.rightBarButtonItem = button
    }

    /// This method is used to fill adapter
    func fillAdapter() {
        // Add foldable cell generators to adapter
        adapter.addCellGenerator(makeFoldableCellGenerator(color: .lightGray,
                                                           expanded: false,
                                                           countChild: 3))

        adapter.addCellGenerator(makeFoldableCellGenerator(color: .lightGray,
                                                           expanded: false,
                                                           countChild: 5))

        adapter.addCellGenerator(makeFoldableCellGenerator(color: .lightGray,
                                                           expanded: false,
                                                           countChild: 2))

        // Tell adapter that we've changed generators
        adapter.forceRefill()
    }

    func makeFoldableCellGenerator(color: UIColor, expanded: Bool, countChild: Int) -> FoldableCollectionCellGenerator {
        // Create foldable generator
        let viewModel = FoldableCollectionViewCell.ViewModel(color: color, expanded: expanded)
        let generator = FoldableCollectionCellGenerator(with: viewModel)

        // Create and add child generators
        generator.childGenerators = makeRegularCellWithTitlesGenerators(count: countChild)

        return generator
    }

    func makeRegularCellWithTitlesGenerators(count: Int) -> [CollectionCellGenerator] {
        let endIndex = count - 1

        guard endIndex > 0 else {
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

    @objc
    func changeListAppearance() {
        switch appearance {
        case .grid:
            let horizontalSectionInset = Constants.sectionInset.left + Constants.sectionInset.right
            let maxWight = UIScreen.main.bounds.width - horizontalSectionInset

            appearance = .table(width: maxWight)
        case .table:
            appearance = .grid
        }

        configureLayoutFlow(with: appearance)
        updateBarButtonItem(with: appearance.title)
    }

}
