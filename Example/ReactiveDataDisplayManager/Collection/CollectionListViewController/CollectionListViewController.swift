//
//  CollectionListViewController.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Vadim Tikhonov on 09.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager

@available(iOS 14.0, *)
class CollectionListViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var collectionView: UICollectionView!

    // MARK: - Properties

    private lazy var adapter = BaseCollectionDataDisplayManager(collection: collectionView)
    private lazy var titles: [String] = ["Item 1", "Item 2", "Item 3", "Item 4"]

    private var appearance = UICollectionLayoutListConfiguration.Appearance.plain

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        fillAdapter()

        configureLayoutFlow()
        updateBarButtonItem()
    }

}

// MARK: - Private Methods

@available(iOS 14.0, *)
private extension CollectionListViewController {

    func fillAdapter() {
        let header = HeaderCollectionListGenerator(title: "Section header")
        adapter.addSectionHeaderGenerator(header)

        for title in titles {
            let generator = TitleCollectionListGenerator(model: title)
            generator.didSelectEvent += { debugPrint("\(title) selected") }
            adapter.addCellGenerator(generator)
        }

        adapter.forceRefill()
    }

    func configureLayoutFlow() {
        var configuration = UICollectionLayoutListConfiguration(appearance: appearance)
        configuration.headerMode = .supplementary
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        collectionView.setCollectionViewLayout(layout, animated: false)
    }

    func updateBarButtonItem() {
        var title: String? = nil
        switch appearance {
        case .plain: title = "Plain"
        case .sidebarPlain: title = "Sidebar Plain"
        case .sidebar: title = "Sidebar"
        case .grouped: title = "Grouped"
        case .insetGrouped: title = "Inset Grouped"
        default: break
        }

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(changeListAppearance))
    }

    @objc
    private func changeListAppearance() {
        switch appearance {
        case .plain: appearance = .sidebarPlain
        case .sidebarPlain: appearance = .sidebar
        case .sidebar: appearance = .grouped
        case .grouped:  appearance = .insetGrouped
        case .insetGrouped: appearance = .plain
        default: break
        }

        updateBarButtonItem()
        configureLayoutFlow()
    }

}

