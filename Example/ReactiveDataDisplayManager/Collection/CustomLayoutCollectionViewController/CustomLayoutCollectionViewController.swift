//
//  File.swift
//  ReactiveDataDisplayManagerExample_iOS
//
//  Created by porohov on 15.11.2021.
//

import UIKit
import ReactiveDataDisplayManager
import Nuke

final class CustomLayoutCollectionViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let size = CGSize(width: 150, height: 150)
        static let padding: CGFloat = 5
        static let insets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }

    // MARK: - IBOutlets

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Private Properties

    private lazy var adapter = collectionView.rddm.baseBuilder
        .build()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        fillAdapter()
        configureLayoutFlow()
    }

}

// MARK: - Private Methods

private extension CustomLayoutCollectionViewController {

    func fillAdapter() {
        adapter.clearCellGenerators()

        adapter.addCellGenerators(makeCellGenerators())

        // Tell adapter that we've changed generators
        adapter.forceRefill()
    }

    
    func configureLayoutFlow() {
        let layout = CustomCollectionViewLayout()
        collectionView.setCollectionViewLayout(layout, animated: true)
    }

    /// Create cell generators
    func makeCellGenerators() -> [CollectionCellGenerator] {
        var generators = [CollectionCellGenerator]()

        for model in makeModels() {
            let generator = BaseCollectionCellGenerator<DifferentSizeCollectionViewCell>(with: model)
            generators.append(generator)
        }

        return generators
    }

    func makeModels() -> [DifferentSizeCollectionViewCellModel] {
        return [
            .init(title: "Task 1", backgroundColor: .red, height: 40),
            .init(title: "Task 2", backgroundColor: .blue, height: 90),
            .init(title: "Task 3", backgroundColor: .yellow, height: 20),
            .init(title: "Task 4", backgroundColor: .green, height: 150)
        ]
    }

}
