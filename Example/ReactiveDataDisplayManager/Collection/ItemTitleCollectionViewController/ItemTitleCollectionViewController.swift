//
//  ItemTitleCollectionViewController.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 18.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager

class ItemTitleCollectionViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        static let itemWidth = UIScreen.main.bounds.width - sectionInset.left - sectionInset.right
        static let itemSize = CGSize(width: itemWidth, height: 150)
        static let models = [("One", true), ("Two", false),
                             ("Three", false), ("Four", true),
                             ("Five", true), ("Six", false),
                             ("Seven", false), ("Eight",  true),
                             ("Nine", false), ("Ten", true)]
    }

    // MARK: - IBOutlets

    @IBOutlet private weak var collectionView: UICollectionView!

    // MARK: - Private Properties

    private lazy var adapter = collectionView.rddm.baseBuilder
        .add(featurePlugin: CollectionItemTitleDisplayablePlugin())
        .build()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        let flowLayout = makeFlowLayout()
        collectionView.setCollectionViewLayout(flowLayout, animated: false)

        fillAdapter()
    }

}

// MARK: - Private methods

private extension ItemTitleCollectionViewController {

    func makeFlowLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 10.0
        flowLayout.sectionInset = Constants.sectionInset
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = Constants.itemSize

        return flowLayout
    }

    /// This method is used to fill adapter
    func fillAdapter() {
        let header = TitleCollectionHeaderGenerator(title: "Header")
        adapter.addSectionHeaderGenerator(header)

        for model in Constants.models {
            // Create generator
            let generator = TitleCollectionGenerator(model: model.0, needIndexTitle: model.1)

            // Add generator to adapter
            adapter.addCellGenerator(generator)
        }

        // Tell adapter that we've changed generators
        adapter.forceRefill()
    }

}
