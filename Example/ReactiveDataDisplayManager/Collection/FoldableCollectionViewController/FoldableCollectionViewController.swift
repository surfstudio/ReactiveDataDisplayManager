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
        static let sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }

    // MARK: - IBOutlet

    @IBOutlet private weak var collectionView: UICollectionView!

    // MARK: - Private Properties

    private lazy var adapter = collectionView.rddm.flowBuilder
        .add(plugin: .foldable())
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
        // Create child generators
        let child1 = makeRegularCellWithTitlesGenerators(count: 3)
        let child2 = makeRegularCellWithTitlesGenerators(count: 5)
        let child3 = makeRegularCellWithTitlesGenerators(count: 2)

        // Create foldable generators
        let folder1 = makeFoldableCellGenerator(color: .lightGray, expanded: false)
        let folder2 = makeFoldableCellGenerator(color: .lightGray, expanded: false)
        let folder3 = makeFoldableCellGenerator(color: .lightGray, expanded: true)

        // Configure relationship
        folder3.childGenerators = child3
        folder2.childGenerators = child2 + [folder3]
        folder1.childGenerators = child1 + [folder2]

        // Add foldable cell generators to adapter
        let visibleGenerators = getVisibleGenerators(for: folder1)
        adapter.addCellGenerators(visibleGenerators)

        // Tell adapter that we've changed generators
        adapter.forceRefill()
    }

    func makeFoldableCellGenerator(color: UIColor, expanded: Bool) -> FoldableCollectionCellGenerator {
        // Create foldable generator
        let viewModel = FoldableCollectionViewCell.ViewModel(color: color)
        let generator = FoldableCollectionCellGenerator(with: viewModel)

        // Configure foldable initial state
        generator.isExpanded = expanded

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
            let generator = ImageCollectionViewCell.rddm.baseGenerator(with: viewModel)
            generators.append(generator)
        }

        return generators
    }

    func getVisibleGenerators(for generator: CollectionCellGenerator) -> [CollectionCellGenerator] {
        if let foldableItem = generator as? RDDMCollectionFoldableItem, foldableItem.isExpanded {
            return foldableItem.childGenerators
                .map { getVisibleGenerators(for: $0) }
                .reduce([generator], +)
        } else {
            return [generator]
        }
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
