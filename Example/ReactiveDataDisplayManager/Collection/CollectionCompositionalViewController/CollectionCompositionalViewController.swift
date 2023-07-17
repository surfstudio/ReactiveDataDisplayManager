//
//  CollectionCompositionaViewController.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Dmitry Korolev on 31.03.2021.
//

import UIKit
import ReactiveDataDisplayManager
import Nuke

@available(iOS 13.0, *)
final class CollectionCompositionalViewController: UIViewController {

    // MARK: - Typealias

    typealias ItemsInvalidationResult = CollectionScrollViewDelegateProxyPlugin.ItemsInvalidationResult

    // MARK: - Constants

    private enum Constants {
        static let boundaryItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50.0))
        static let edgeInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        static let fraction: CGFloat = 1.0 / 2
        static let minScale: CGFloat = 0.8
        static let maxScale: CGFloat = 1
    }

    // MARK: - IBOutlets

    @IBOutlet private weak var collectionView: UICollectionView!

    // MARK: - Private Properties

    private let prefetcher = NukeImagePrefetcher(placeholder: #imageLiteral(resourceName: "ReactiveLogo"))
    private lazy var prefetcherablePlugin: CollectionImagePrefetcherablePlugin = .prefetch(prefetcher: prefetcher)

    private let scrrollPlugin = CollectionScrollViewDelegateProxyPlugin()
    private lazy var adapter = collectionView.rddm.baseBuilder
        .add(plugin: prefetcherablePlugin)
        .add(plugin: scrrollPlugin)
        .add(plugin: .scrollOnSelect(to: .centeredHorizontally))
        .build()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Compositional layout"
        fillAdapter()
    }

}

// MARK: - Private Methods

@available(iOS 13.0, *)
private extension CollectionCompositionalViewController {

    func fillAdapter() {
        collectionView.setCollectionViewLayout(makeCompositionalLayout(), animated: false)
        addAnimationSection()
        addGridSection()
        addCompositeGroupSection()
        adapter => .reload

        // Handle table offset
        scrrollPlugin.didScroll += { collectionView in
            print(collectionView.contentOffset.y)
        }

        // Handle section offset
        scrrollPlugin.didScrollCompositionLayoutSection += { [weak self] result in
            print(result.offset.x)
            result.applyScale(minScale: Constants.minScale, maxScale: Constants.maxScale, aligment: .center)
            result.applyCentredPosition(collectionView: self?.collectionView)
        }
    }

    func addAnimationSection() {
        addHeaderFooterGenerator(header: "Animate section begin", footer: "Animate section end")
        for _ in 0...29 {
            // Create viewModels for cell
            guard let viewModel = ImageCollectionViewCell.ViewModel.make(with: loadImage) else { continue }

            // Create generator
            let generator = ImageCollectionViewCell.rddm.baseGenerator(with: viewModel)

            // Add generator to adapter
            adapter += generator
        }
    }

    func addGridSection() {
        addHeaderFooterGenerator(header: "Grid section begin", footer: "Grid section end")
        for index in 0...11 {
            // Create generator
            let needIndexTitle = index % 2 == 0 ? true : false
            let generator = TitleCollectionGenerator(model: "Item \(index)", needIndexTitle: needIndexTitle)

            // Add generator to adapter
            adapter += generator
        }
    }

    func addCompositeGroupSection() {
        addHeaderFooterGenerator(header: "Composite group section begin", footer: "Composite group section end")
        for _ in 0...31 {
            // Create viewModels for cell
            guard let viewModel = ImageCollectionViewCell.ViewModel.make(with: loadImage) else { continue }

            // Create generator
            let generator = ImageCollectionViewCell.rddm.baseGenerator(with: viewModel)

            // Add generator to adapter
            adapter += generator
        }
    }

    /// This method load image and set to UIImageView
    func loadImage(url: URL, imageView: UIImageView) {
        Nuke.loadImage(with: url, options: prefetcher.imageLoadingOptions, into: imageView)
    }

    func addHeaderFooterGenerator(header: String, footer: String) {
        // Make header generator
        let headerGenerator = TitleCollectionHeaderGenerator(title: header)
        let footerGenerator = TitleIconCollectionFooterGenerator(title: footer)

        // Add header generator into adapter
        adapter += headerGenerator
        adapter += footerGenerator
    }

}

// MARK: - UICollectionViewCompositionalLayout Helper Methods

@available(iOS 13.0, *)
private extension CollectionCompositionalViewController {

    func makeCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] (sectionNumber, _) -> NSCollectionLayoutSection? in
            switch sectionNumber {
            case 0:
                return self?.animationLayout() // Animate section
            case 1:
                return self?.gridLayout() // Grid section
            default:
                return self?.compositeGroupLayout() // Composite group section
            }
        }
    }

    // Animation section
    func animationLayout() -> NSCollectionLayoutSection {
        // Header
        let header = makeSectionHeader()

        // Footer
        let footer = makeSectionFooter()

        // Item
        let item = NSCollectionLayoutItem(layoutSize: makeLayoutSize(for: .init(width: 1, height: 1)))

        // Group
        let groupSize = makeLayoutSize(for: .init(width: Constants.fraction, height: Constants.fraction))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 30, leading: 0, bottom: 0, trailing: 0)
        section.boundarySupplementaryItems = [header, footer] // add custom element (footer, header, ....)
        section.setHorizontalScroll(type: .groupPagingCentered, with: scrrollPlugin)
        return section
    }

    // Grid section
    func gridLayout() -> NSCollectionLayoutSection {
        // Header
        let header = makeSectionHeader()

        // Footer
        let footer = makeSectionFooter()

        // Item
        let item = makeItem(with: .init(width: 0.33, height: 1.0))

        // Group
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: makeLayoutSize(for: .init(width: 1.0, height: 0.2)), subitems: [item])

        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header, footer] // add custom element (footer, header, ....)
        return section
    }

    // Composite group section
    func compositeGroupLayout() -> NSCollectionLayoutSection {
        // Header
        let header = makeSectionHeader()

        // Footer
        let footer = makeSectionFooter()

        // Item medium image
        let leadingItem = makeItem(with: .init(width: 0.7, height: 1.0))

        // Item small image
        let trailingItem = makeItem(with: .init(width: 1.0, height: 0.3))

        // Group combine 2 small image
        let trailingGroup = NSCollectionLayoutGroup.vertical(layoutSize: makeLayoutSize(for: .init(width: 0.3, height: 1.0)),
                                                             subitem: trailingItem,
                                                             count: 2)

        // Group combine medium image | 2 small image
        let bottomNestedGroup = NSCollectionLayoutGroup.horizontal(layoutSize: makeLayoutSize(for: .init(width: 1.0, height: 0.6)),
                                                                   subitems: [leadingItem, trailingGroup])

        // Item long image)
        let topItem = makeItem(with: .init(width: 1.0, height: 0.3))

        // Main Group long image / medium image | 2 small image
        let nestedGroup = NSCollectionLayoutGroup.vertical(layoutSize: makeLayoutSize(for: .init(width: 1.0, height: 0.4)),
                                                           subitems: [topItem, bottomNestedGroup])

        // Section
        let section = NSCollectionLayoutSection(group: nestedGroup)
        section.orthogonalScrollingBehavior = .groupPaging
        section.boundarySupplementaryItems = [header, footer] // add custom element (footer, header, ....)
        return section
    }

    func makeSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        return NSCollectionLayoutBoundarySupplementaryItem(layoutSize: Constants.boundaryItemSize,
                                                           elementKind: UICollectionView.elementKindSectionHeader,
                                                           alignment: .top)
    }

    func makeSectionFooter() -> NSCollectionLayoutBoundarySupplementaryItem {
        return NSCollectionLayoutBoundarySupplementaryItem(layoutSize: Constants.boundaryItemSize,
                                                           elementKind: UICollectionView.elementKindSectionFooter,
                                                           alignment: .bottom)
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
