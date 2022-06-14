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

    private enum Constants {
        static let multiple = "Multiple mode"
        static let standart = "Single mode"
    }

    // MARK: - IBOutlets

    @IBOutlet private weak var collectionView: UICollectionView!

    // MARK: - Private Properties

    private lazy var adapter = collectionView.rddm.baseBuilder
        .add(plugin: .selectable())
        .add(plugin: .highlightable())
        .build()

    private lazy var titles: [String] = ["One", "Two", "Three", "Four"]

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.accessibilityIdentifier = "Collection_with_selectable_cells"
        fillAdapter()
        updateBarButtonItem(with: Constants.standart)
    }

    // MARK: - Private methods
}

// MARK: - Private Methods

private extension CollectionViewController {

    /// This method is used to fill adapter
    func fillAdapter() {
        let header = TitleCollectionHeaderGenerator(title: "Header")
        adapter.addSectionHeaderGenerator(header)
        for title in titles {
            // Create generator
            let generator = TitleCollectionViewCell.rddm.baseGenerator(with: title)
            generator.didSelectEvent += {
                debugPrint("\(title) selected")
            }
            generator.didDeselectEvent += {
                debugPrint("\(title) deselected")
            }
            // Add generator to adapter
            adapter.addCellGenerator(generator)
        }

        // Tell adapter that we've changed generators
        adapter.forceRefill()
    }

    func updateBarButtonItem(with title: String) {
        let button = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(toggleAllowsMultiple))
        navigationItem.rightBarButtonItem = button
    }

    @objc
    func toggleAllowsMultiple() {
        adapter.generators.forEach { $0.forEach { ($0 as? SelectableItem)?.isNeedDeselect.toggle() } }
        adapter.view.allowsMultipleSelection.toggle()
        updateBarButtonItem(with: collectionView.allowsMultipleSelection ? Constants.multiple : Constants.standart)
    }

}
