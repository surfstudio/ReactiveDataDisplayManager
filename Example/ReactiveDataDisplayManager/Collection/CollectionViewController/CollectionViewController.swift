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
        .set(delegate: FlowCollectionDelegate())
        .add(plugin: .selectable())
        .add(plugin: .highlightable())
        .add(plugin: .accessibility())
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

        // Added one section
        adapter += CollectionSection(
            generators: makeGenerators(),
            header: TitleCollectionHeaderGenerator(title: "Header")
        )

        // Tell adapter that we've changed generators
        adapter => .reload
    }

    func makeGenerators() -> [CollectionCellGenerator] {
        CollectionGenerators {
            titles.map { title -> CollectionCellGenerator in
                // Create generator
                let generator = TitleCollectionViewCell.rddm.calculatableHeightGenerator(with: title, referencedWidth: 100)
                generator.didSelectEvent += {
                    debugPrint("\(title) selected")
                }
                generator.didDeselectEvent += {
                    debugPrint("\(title) deselected")
                }
                return generator
            }
        }
    }

    func updateBarButtonItem(with title: String) {
        let button = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(toggleAllowsMultiple))
        navigationItem.rightBarButtonItem = button
    }

    @objc
    func toggleAllowsMultiple() {
        adapter.sections
            .flatMap(\.generators)
            .forEach { ($0 as? SelectableItem)?.isNeedDeselect.toggle() }
        adapter.view.allowsMultipleSelection.toggle()
        updateBarButtonItem(with: collectionView.allowsMultipleSelection ? Constants.multiple : Constants.standart)
    }

}
