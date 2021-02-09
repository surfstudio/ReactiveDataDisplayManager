//
//  CollectionListViewController.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Vadim Tikhonov on 09.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import UIKit

import UIKit
import ReactiveDataDisplayManager

class CollectionListViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var collectionView: UICollectionView!

    // MARK: - Properties

    private lazy var adapter = BaseCollectionDataDisplayManager(collection: collectionView)
    private lazy var titles: [String] = ["One", "Two", "Three", "Four"]

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        fillAdapter()
    }

    // MARK: - Private methods

    /// This method is used to fill adapter
    private func fillAdapter() {
        let header = TitleCollectionHeaderGenerator(title: "Header")
        adapter.addSectionHeaderGenerator(header)
        for title in titles {
            // Create generator
            let generator = TitleCollectionGenerator(model: title)
            generator.didSelectEvent += {
                debugPrint("\(title) selected")
            }
            // Add generator to adapter
            adapter.addCellGenerator(generator)
        }

        // Tell adapter that we've changed generators
        adapter.forceRefill()
    }

}


