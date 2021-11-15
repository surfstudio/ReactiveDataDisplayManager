//
//  File.swift
//  ReactiveDataDisplayManagerExample_iOS
//
//  Created by porohov on 15.11.2021.
//

import UIKit
import ReactiveDataDisplayManager

final class FittingCompressedSizeCollectionViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let size = CGSize(width: 150, height: 150)
        static let padding: CGFloat = 5
        static let insets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        static let sizesAndColors: [(text: String, color: UIColor)] = [
            (text: "Lorem ipsum dolor sit amet,",
             color: .yellow),

            (text: "consectetur adipiscing elit. consectetur adipiscing elit. Nunc magna libero, imperdiet a risus eget, ornare sodales leo.",color: .blue),

            (text: "Nunc a mauris dui. Integer consectetur hendrerit feugiat. Phasellus id quam ligula.", color: .green),

            (text: "Integer consectetur hendrerit feugiat. Phasellus id quam ligula. Integer consectetur hendrerit feugiat. Phasellus id quam ligula. Maecenas diam erat, interdum fermentum auctor eu, mattis id libero.", color: .red),

            (text: "Duis commodo facilisis ligula eget vestibulum. Praesent vel nisl non sapien scelerisque auctor.", color: .gray)
        ]
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

private extension FittingCompressedSizeCollectionViewController {

    func fillAdapter() {
        adapter.clearCellGenerators()

        // Add generators in adapter
        adapter.addCellGenerators(makeCellGenerators())

        // Tell adapter that we've changed generators
        adapter.forceRefill()
    }

    /// CustomCollectionViewLayout
    func configureLayoutFlow() {
        let layout = FittingCompressedSizeCollectionViewLayout()
        collectionView.setCollectionViewLayout(layout, animated: true)
    }

    /// Create cell generators
    func makeCellGenerators() -> [CollectionCellGenerator] {
        var generators = [CollectionCellGenerator]()

        for model in makeModels() {
            let generator = BaseCollectionCellGenerator<FittingCompressedSizeCollectionViewCell>(with: model)
            generators.append(generator)
        }

        return generators
    }

    /// Create models for cells
    func makeModels() -> [DifferentSizeCollectionViewCellModel] {
        var models: [DifferentSizeCollectionViewCellModel] = []
        for typle in Constants.sizesAndColors {
            models.append(.init(title: typle.text, backgroundColor: typle.color))
        }
        return models
    }

}
