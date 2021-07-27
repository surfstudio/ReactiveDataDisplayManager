//
//  GalleryController.swift
//  ReactiveDataDisplayManagerExample_iOS
//
//  Created by Никита Коробейников on 09.06.2021.
//

import UIKit
import Nuke
import ReactiveDataDisplayManager

final class GalleryController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let boundaryItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                             heightDimension: .absolute(100))
        static let edgeInsets = NSDirectionalEdgeInsets(top: 0, leading: 40, bottom: 40, trailing: 40)
    }

    // MARK: - IBOutlet

    @IBOutlet private weak var collectionView: UICollectionView!

    // MARK: - Private Properties

    private lazy var adapter = collectionView.rddm.baseBuilder
        .add(plugin: .scrollOnSelect(to: .centeredHorizontally))
        .add(featurePlugin: .focusable())
        .add(plugin: .selectable())
        .build()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "GalleryController"

        configureCollectionView()

        fillAdapter()
    }

}

// MARK: - Private Methods

private extension GalleryController {

    func configureCollectionView() {
        collectionView.decelerationRate = .fast
        collectionView.showsHorizontalScrollIndicator = false

        collectionView.setCollectionViewLayout(makeCompositionalLayout(), animated: false)
    }

    /// This method is used to fill adapter
    func fillAdapter() {
        for i in 0...10 {
            let headerGenerator = TitleCollectionHeaderGenerator(title: "Recommendations \(i)")

            adapter.addSectionHeaderGenerator(headerGenerator)
            for _ in 0...31 {
                // Create viewModels for cell
                guard let viewModel = ImageViewModel.make(with: loadImage) else { continue }

                // Create generator
                let generator = ImageCollectionViewGenerator(with: viewModel)

                generator.didSelectEvent += {
                    print(viewModel.imageUrl)
                }

                // Add generator to adapter
                adapter.addCellGenerator(generator)
            }
        }

        // Tell adapter that we've changed generators
        adapter.forceRefill()
    }

    /// This method load image and set to UIImageView
    func loadImage(url: URL, imageView: UIImageView) {
        Nuke.loadImage(with: url, into: imageView)
    }

    func makeCompositionalLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] (sectionNumber, _) -> NSCollectionLayoutSection? in
            self?.gridLayout()
        }
    }

    // Grid section
    func gridLayout() -> NSCollectionLayoutSection {
        // Header
        let header = makeSectionHeader()

        // Item
        let item = makeItem(with: .init(width: 0.2, height: 1.0))

        // Group
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: makeLayoutSize(for: .init(width: 1.0, height: 0.2)),
                                                       subitems: [item])

        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.boundarySupplementaryItems = [header] // add custom element (header, ....)
        return section
    }

    func makeSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        return NSCollectionLayoutBoundarySupplementaryItem(layoutSize: Constants.boundaryItemSize,
                                                           elementKind: UICollectionView.elementKindSectionHeader,
                                                           alignment: .top)
    }

    func makeItem(with size: CGSize, contentInsets: NSDirectionalEdgeInsets = Constants.edgeInsets) -> NSCollectionLayoutItem {
        let layoutSize = makeLayoutSize(for: size)
        let item = NSCollectionLayoutItem(layoutSize: layoutSize)
        item.contentInsets = contentInsets
        return item
    }

    func makeLayoutSize(for size: CGSize) -> NSCollectionLayoutSize {
        return NSCollectionLayoutSize(widthDimension: .fractionalWidth(size.width),
                                      heightDimension: .fractionalHeight(size.height))
    }

}
