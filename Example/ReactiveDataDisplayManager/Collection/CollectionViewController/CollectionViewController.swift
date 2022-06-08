//
//  CollectionViewController.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Ivan Smetanin on 27/01/2018.
//  Copyright © 2018 Alexander Kravchenkov. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager

class CollectionViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var collectionView: UICollectionView!

    // MARK: - Private Properties

    private lazy var adapter = collectionView.rddm.baseBuilder
        .add(plugin: .selectable())
        .build()

    private lazy var titles: [String] = ["One", "Two", "Three", "Four"]

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        fillAdapter()
        collectionView.allowsMultipleSelection = true
    }

    // MARK: - Private methods

    /// This method is used to fill adapter
    private func fillAdapter() {
        let header = TitleCollectionHeaderGenerator(title: "Header")
        adapter.addSectionHeaderGenerator(header)
        for title in titles {
            // Create generator
            let generator = TitleCollectionGenerator(model: title)
            generator.isNeedDeselect = false

            generator.didSelectEvent += { [weak generator] in
                generator?.cell?.configure(with: "selected")
            }
            generator.didDeselectEvent += { [weak generator] in
                generator?.cell?.configure(with: title)
            }
            // Add generator to adapter
            adapter.addCellGenerator(generator)
        }

        // Tell adapter that we've changed generators
        adapter.forceRefill()
    }

}
