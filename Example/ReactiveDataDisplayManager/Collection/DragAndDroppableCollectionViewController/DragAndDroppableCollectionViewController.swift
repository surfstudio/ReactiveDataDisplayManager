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
        static let titleForSectionFirst = "SectionFirst"
        static let titleForSectionLast = "SectionLast"
    }

    // MARK: - IBOutlets

    @IBOutlet private weak var collectionView: UICollectionView!

    // MARK: - Private Properties

    private var generators = [TitleCollectionGenerator]()
    private let dragAndDroppablePlugin: CollectionDragAndDroppablePlugin = .dragAndDroppable(by: .current)
    private lazy var adapter = collectionView.rddm.baseBuilder
        .set(delegate: FlowCollectionDelegate())
        .add(featurePlugin: dragAndDroppablePlugin)
        .build()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Collection with drag'n'drop items"

        configureLayoutFlow()
        collectionView.accessibilityIdentifier = "Collection_with_drag_n_drop_items"
        collectionView.dragInteractionEnabled = true

        fillAdapter()

        dragAndDroppablePlugin.droppableDelegate.cellDidChangePosition = { [weak self] result in
            let generator = self?.generators.first(where: { $0.title == result.id })
        }
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
        // Add generators to adapter
        adapter.addSectionHeaderGenerator(TitleCollectionHeaderGenerator(title: Constants.titleForSectionFirst))
        adapter.addCellGenerators(makeCellGenerators(for: Array(1...10)))
        adapter.addSectionHeaderGenerator(TitleCollectionHeaderGenerator(title: Constants.titleForSectionLast))
        adapter.addCellGenerators(makeCellGenerators(for: Array(11...20)))

        // Tell adapter that we've changed generators
        adapter.forceRefill()
    }

    /// Create cells generators for range
    func makeCellGenerators(for range: [Int]) -> [CollectionCellGenerator] {
        for index in range {
            let generator = TitleCollectionGenerator(model: "Cell: \(index)")
            generators.append(generator)
        }

        return generators
    }

}
