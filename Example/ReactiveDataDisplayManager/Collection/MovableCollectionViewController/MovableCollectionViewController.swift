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
        static let titleForSection = "Section"
        static let models = [String](repeating: "movable cell", count: 5)
    }

    // MARK: - IBOutlets

    @IBOutlet private weak var collectionView: UICollectionView!

    // MARK: - Private Properties

    private lazy var adapter = collectionView.rddm.baseBuilder
        .add(featurePlugin: .movable())
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
        title = "Collection with movable cell"

        configureCollectionView()
        fillAdapter()
    }

    func configureCollectionView() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture(gesture:)))
        collectionView.addGestureRecognizer(longPressGesture)
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
        return Constants.models.enumerated().map { MovableCollectionCellGenerator(with: "\($0.element) \($0.offset)") }
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
            collectionView.collectionViewLayout.invalidateLayout()
        default:
            collectionView.cancelInteractiveMovement()
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }

}
