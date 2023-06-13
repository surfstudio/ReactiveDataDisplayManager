//
//  MovableCollectionViewController.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 15.04.2021.
//

import UIKit
import ReactiveDataDisplayManager

final class MovableCollectionViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        enum CollectionLayout {
            static let cellSize = CGSize(width: 120, height: 120)
            static let sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
        }

        static let titleForSection = "Section"
        static let models = [String](repeating: "Cell", count: 5)
    }

    // MARK: - IBOutlets

    @IBOutlet private weak var collectionView: UICollectionView!

    // MARK: - Private Properties

    private let movablePlugin: CollectionMovableItemPlugin = .movable()
    private lazy var adapter = collectionView.rddm.baseBuilder
        .set(delegate: FlowCollectionDelegate())
        .add(featurePlugin: .movable(cellDidChangePosition: { print($0.id ?? "") }))
        .build()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialState()
    }

}

// MARK: - Private methods

private extension MovableCollectionViewController {

    func setupInitialState() {
        title = "movable cell"

        configureCollectionView()
        fillAdapter()
    }

    func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = Constants.CollectionLayout.cellSize
        layout.sectionInset = Constants.CollectionLayout.sectionInset
        collectionView.setCollectionViewLayout(layout, animated: false)

        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture(gesture:)))
        collectionView.addGestureRecognizer(longPressGesture)

        collectionView.dragInteractionEnabled = false
        collectionView.accessibilityIdentifier = "Collection_with_movable_cell"
    }

    /// This method is used to fill adapter
    func fillAdapter() {
        // Add generator to adapter
        adapter.addCellGenerators(makeMovableCellGenerators())

        // Tell adapter that we've changed generators
        adapter.forceRefill()
    }

    // Create cells generators
    func makeMovableCellGenerators() -> [MovableCollectionCellGenerator] {
        Constants.models.enumerated()
            .map { MovableCollectionCellGenerator(id: $0.offset,
                                                  model: "\($0.element) \($0.offset)",
                                                  referencedWidth: 128)
            }
    }

}

// MARK: - Actions

private extension MovableCollectionViewController {

    @objc
    func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            let location = gesture.location(in: collectionView)
            guard let selectedIndexPath = collectionView.indexPathForItem(at: location) else { break }
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            let location = gesture.location(in: collectionView)
            collectionView.updateInteractiveMovementTargetPosition(location)
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }

}
