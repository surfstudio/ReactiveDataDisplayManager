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
class CollectionCompositionalViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let edgeInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
    }

    // MARK: - IBOutlets

    @IBOutlet private weak var collectionView: UICollectionView!

    // MARK: - Private Properties

    private let prefetcher = NukeImagePrefetcher(placeholder: #imageLiteral(resourceName: "ReactiveLogo"))
    private lazy var prefetcherablePlugin: CollectionPrefetcherablePlugin<NukeImagePrefetcher, ImageCollectionCellGenerator> = .prefetch(prefetcher: prefetcher)

    private lazy var adapter = collectionView.rddm.baseBuilder
        .add(plugin: prefetcherablePlugin)
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
        adapter.forceRefill()
    }
    
    func addAnimationSection() {
        addHeaderFooterGenerator(header: "Animate section begin", footer: "Animate section end")
        for _ in 0...29 {
            // Create viewModels for cell
            guard let viewModel = ImageCollectionViewCell.ViewModel.make(with: loadImage) else { continue }

            // Create generator
            let generator = ImageCollectionViewCell.rddm.baseGenerator(with: viewModel)

            // Add generator to adapter
            adapter.addCellGenerator(generator)
        }
    }
    
    func addGridSection() {
        addHeaderFooterGenerator(header: "Grid section begin", footer: "Grid section end")
        for index in 0...11 {
            // Create generator
            let generator = TitleCollectionGenerator(model: "Item \(index)", needIndexTitle: index % 2 == 0 ? true : false)

            // Add generator to adapter
            adapter.addCellGenerator(generator)
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
            adapter.addCellGenerator(generator)
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
        adapter.addSectionHeaderGenerator(headerGenerator)
        adapter.addSectionFooterGenerator(footerGenerator)
    }

}

//MARK: - UICollectionViewCompositionalLayout Helper Methods

@available(iOS 13.0, *)
private extension CollectionCompositionalViewController {

    func makeCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            switch sectionNumber {
            case 0:
                return self.animationLayout() // Animate section
            case 1:
                return self.gridLayout() // Grid section
            default:
                return self.compositeGroupLayout() // Composite group section
            }
        }
    }

    func makeSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(50.0))

        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: UICollectionView.elementKindSectionHeader,
                                                                 alignment: .top)
        return header
    }
    
    func makeSectionFooter() -> NSCollectionLayoutBoundarySupplementaryItem {
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(50.0))

        let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize,
                                                                 elementKind: UICollectionView.elementKindSectionFooter,
                                                                 alignment: .bottom)
        return footer
    }

    // Animation section
    func animationLayout() -> NSCollectionLayoutSection {
        let fraction: CGFloat = 1.0 / 3.0

        // Header
        let header = makeSectionHeader()
        
        // Footer
        let footer = makeSectionFooter()

        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction),
                                               heightDimension: .fractionalWidth(fraction))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 30, leading: 0, bottom: 0, trailing: 0)
        section.orthogonalScrollingBehavior = .groupPaging
        section.boundarySupplementaryItems = [header, footer] // add custom element (footer, header, ....)
        section.visibleItemsInvalidationHandler = { items, offset, environment in
            
            // Remove header from cells
            let cellWithoutHeaderOrFooter = items.filter {
                $0.representedElementKind == .none
            }
            let contentWidth = environment.container.contentSize.width
            let minScale: CGFloat = 0.7
            let maxScale: CGFloat = 1.1

            // Transform cells
            cellWithoutHeaderOrFooter.forEach { item in
                let height = item.bounds.height/2
                let distanceFromCenter = abs(item.frame.midX - offset.x - contentWidth / 2.0)
                let scale = max(maxScale - distanceFromCenter / contentWidth, minScale)

                item.transform = CGAffineTransform(translationX: 0, y: height)
                    .scaledBy(x: scale, y: scale)
                    .translatedBy(x: 0, y: -height)
            }
        }
        return section
    }

    // Grid section
    func gridLayout() -> NSCollectionLayoutSection {
        // Header
        let header = makeSectionHeader()

        // Footer
        let footer = makeSectionFooter()

        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = Constants.edgeInsets

        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(0.2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

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
        let leadingItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.7),
                                               heightDimension: .fractionalHeight(1.0)))
        leadingItem.contentInsets = Constants.edgeInsets

        // Item small image
        let trailingItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.3)))
        trailingItem.contentInsets = Constants.edgeInsets
        
        // Group combine 2 small image
        let trailingGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3),
                                                       heightDimension: .fractionalHeight(1.0))
        let trailingGroup = NSCollectionLayoutGroup.vertical(layoutSize: trailingGroupSize,
                                                             subitem: trailingItem,
                                                             count: 2)

        // Group combine medium image | 2 small image
        let bottomNestedGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                           heightDimension: .fractionalHeight(0.6))
        let bottomNestedGroup = NSCollectionLayoutGroup.horizontal(layoutSize: bottomNestedGroupSize,
                                                                   subitems: [leadingItem, trailingGroup])

        // Item long image)
        let topItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.3)))
        topItem.contentInsets = Constants.edgeInsets

        // Main Group long image / medium image | 2 small image
        let nestedGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .fractionalHeight(0.4))
        let nestedGroup = NSCollectionLayoutGroup.vertical(layoutSize: nestedGroupSize,
                                                           subitems: [topItem, bottomNestedGroup])

        // Section
        let section = NSCollectionLayoutSection(group: nestedGroup)
        section.orthogonalScrollingBehavior = .groupPaging
        section.boundarySupplementaryItems = [header, footer] // add custom element (footer, header, ....)
        return section
    }

}
