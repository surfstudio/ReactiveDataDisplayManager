//
//  DragAndDroppableCollectionViewController.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 18.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager
import Nuke

final class DragAndDroppableCollectionViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }

    // MARK: - IBOutlet

    @IBOutlet private weak var collectionView: UICollectionView!

    // MARK: - Private Properties

    private lazy var adapter = collectionView.rddm.baseBuilder
        .add(featurePlugin: CollectionDragAndDroppablePlugin())
        .build()

    private var appearance: Appearance = .grid

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Collection with drag'n'drop items"

        configureLayoutFlow(with: appearance)
        updateBarButtonItem(with: appearance.title)
        collectionView.dragInteractionEnabled = true

        fillAdapter()
    }

}

// MARK: - Private Methods

private extension DragAndDroppableCollectionViewController {

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
        // Create cell generators
        let generators = makeCellGenerators()

        // Add cell generators to adapter
        adapter.addCellGenerators(generators)

        // Tell adapter that we've changed generators
        adapter.forceRefill()
    }

    func makeCellGenerators() -> [CollectionCellGenerator] {
        var generators = [CollectionCellGenerator]()

        for _ in 0...30 {
            guard let viewModel = ImageCollectionViewCell.ViewModel.make() else { continue }
            let generator = DragAndDroppableCollectionGenerator(with: viewModel)
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
