//
//  SwipeableCollectionListViewController.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Anton Eysner on 19.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager

@available(iOS 14.0, *)
class SwipeableCollectionListViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let titles = ["Item 1", "Item 2", "Item 3", "Item 4"]
    }

    // MARK: - IBOutlets

    @IBOutlet private weak var collectionView: UICollectionView!

    // MARK: - Private Properties

    private let swipeProvider = SwipeActionProvider()
    private lazy var plugin = CollectionSwipeActionsConfigurationPlugin(swipeProvider: swipeProvider)
    private lazy var adapter = collectionView.rddm.baseBuilder
        .add(featurePlugin: plugin)
        .build()

    private var appearance = UICollectionLayoutListConfiguration.Appearance.plain

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "List Appearances with swipeable items"
        fillAdapter()

        configureLayoutFlow(with: appearance)
        updateBarButtonItem(with: appearance.title)
    }

}

// MARK: - Private Methods

@available(iOS 14.0, *)
private extension SwipeableCollectionListViewController {

    func fillAdapter() {
        let header = HeaderCollectionListGenerator(title: "Section header")
        adapter.addSectionHeaderGenerator(header)

        for title in Constants.titles {
            let generator = SwipeableCollectionGenerator(with: title)

            generator.didSwipeEvent += { [weak generator] actionType in
                debugPrint("The action with type \(actionType) was selected from all available generator events \(generator?.actionTypes ?? [])")
            }

            adapter.addCellGenerator(generator)
        }

        adapter.forceRefill()
    }

    func configureLayoutFlow(with appearance: UICollectionLayoutListConfiguration.Appearance) {
        var configuration = UICollectionLayoutListConfiguration(appearance: appearance)
        configuration.headerMode = .supplementary
        plugin.configureSwipeActions(for: &configuration)

        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        collectionView.setCollectionViewLayout(layout, animated: false)
    }

    func updateBarButtonItem(with title: String) {
        let button = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(changeListAppearance))
        navigationItem.rightBarButtonItem = button
    }

    @objc
    func changeListAppearance() {
        appearance = appearance.next

        configureLayoutFlow(with: appearance)
        updateBarButtonItem(with: appearance.title)
    }

}
