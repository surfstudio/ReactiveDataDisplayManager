//
//  SizableCollectionViewController.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Vadim Tikhonov on 11.02.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager

final class SizableCollectionViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }

    // MARK: - IBOutlet

    @IBOutlet private weak var collectionView: UICollectionView!

    // MARK: - Private Properties

    private lazy var adapter = collectionView.rddm.baseBuilder
        .set(delegate: FlowCollectionDelegate())
        .build()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sizable collection"

        let flowLayout = makeFlowLayout()
        collectionView.setCollectionViewLayout(flowLayout, animated: false)

        fillAdapter()
    }

}

// MARK: - Private Methods

private extension SizableCollectionViewController {

    func makeFlowLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 10.0
        flowLayout.sectionInset = Constants.sectionInset
        flowLayout.scrollDirection = .vertical

        return flowLayout
    }

    /// This method is used to fill adapter
    func fillAdapter() {
        let horizontalSectionInset = Constants.sectionInset.left + Constants.sectionInset.right
        let collectionWight = UIScreen.main.bounds.width - horizontalSectionInset

        // swiftlint:disable line_length
        let sampleText = """
            Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
        """
        // swiftlint:enable line_length

        for _ in 0...300 {
            // Create viewModels for cell
            let maxLength = Int.random(in: 50...sampleText.count)
            let viewModel = String(sampleText.prefix(maxLength))

            // Create generator
            let generator = VerticalSizableTextGenerator(with: viewModel, maxWight: collectionWight)

            // Add generator to adapter
            adapter.addCellGenerator(generator)
        }

        // Tell adapter that we've changed generators
        adapter.forceRefill()
    }

}
