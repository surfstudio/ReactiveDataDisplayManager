//
//  DragAndDroppableCollectionViewController.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 18.02.2021.
//

import UIKit
import ReactiveDataDisplayManager

final class DragAndDroppableCollectionViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        static let cellSize = CGSize(width: 120, height: 120)
    }

    // MARK: - IBOutlets

    @IBOutlet private weak var collectionView: UICollectionView!

    // MARK: - Private Properties

    private lazy var adapter = collectionView.rddm.baseBuilder
        .add(featurePlugin: .dragAndDroppable())
        .build()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Collection with drag'n'drop items"

        configureLayoutFlow()
        collectionView.dragInteractionEnabled = true

        fillAdapter()
    }

}

// MARK: - Private Methods

private extension DragAndDroppableCollectionViewController {

    func configureLayoutFlow() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = Constants.cellSize
        flowLayout.minimumLineSpacing = 10.0
        flowLayout.minimumInteritemSpacing = 10.0
        flowLayout.sectionInset = Constants.sectionInset
        flowLayout.scrollDirection = .vertical

        collectionView.setCollectionViewLayout(flowLayout, animated: true)
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

    /// Create cell generators
    func makeCellGenerators() -> [CollectionCellGenerator] {
        var generators = [CollectionCellGenerator]()

        for index in 0...10 {
            let generator = TitleCollectionGenerator(model: "Cell: \(index)")
            generators.append(generator)
        }

        return generators
    }

}
