//
//  RefreshableCollectionViewController.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by porohov on 05.07.2022.
//

import UIKit
import ReactiveDataDisplayManager

final class RefreshableCollectionViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let titles = ["Item 1", "Item 2", "Item 3", "Item 4"]
        static let cellHeight = 40.0
        static let cellSpacing = 16.0
    }

    // MARK: - IBOutlets

    @IBOutlet private weak var collectionView: UICollectionView!

    // MARK: - Private Properties

    private var refreshControl: UIRefreshControl {
        let refreshControl = UIRefreshControl()
        refreshControl.isAccessibilityElement = true
        refreshControl.accessibilityIdentifier = "RefreshableCollectionViewController_RefreshControl"
        return refreshControl
    }

    private lazy var adapter = collectionView.rddm.baseBuilder
        .add(plugin: .refreshable(refreshControl: refreshControl, output: self))
        .build()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Refrashable collection list"
        collectionView.accessibilityIdentifier = "Refrashable_collection_list"
        fillAdapter()

        configureLayoutFlow()
    }

}

// MARK: - Private Methods

private extension RefreshableCollectionViewController {

    /// This method is used to fill adapter
    func fillAdapter() {
        // Create header generator
        let header = HeaderCollectionListGenerator(title: "Section header")

        // Add the header generator into adapter
        adapter.addSectionHeaderGenerator(header)

        for title in Constants.titles {
            // Create cell generator
            let generator = TitleCollectionListCell.rddm.baseGenerator(with: title)

            // Add cell generator into adapter
            adapter.addCellGenerator(generator)
        }

        // Tell adapter that we've changed generators
        adapter.forceRefill()
    }

    func configureLayoutFlow() {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width - Constants.cellSpacing * 2
        layout.itemSize = .init(width: width, height: Constants.cellHeight)
        collectionView.setCollectionViewLayout(layout, animated: false)
    }

}

extension RefreshableCollectionViewController: RefreshableOutput {

    func refreshContent(with input: RefreshableInput) {

        delay(.now() + .seconds(3)) { [weak self, weak input] in
            self?.adapter.clearCellGenerators()

            for index in 1...4 {
                let generator = TitleCollectionListCell.rddm.baseGenerator(with: "Refreshing \(index)")
                self?.adapter.addCellGenerator(generator)
            }

            self?.adapter.forceRefill()

            input?.endRefreshing()
        }
    }

}
