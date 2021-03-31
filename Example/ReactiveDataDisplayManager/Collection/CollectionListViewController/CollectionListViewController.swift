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

    // MARK: - Private Properties

    private lazy var adapter = collectionView.rddm.baseBuilder
        .add(plugin: .selectable())
        .add(plugin: .foldable())
        .add(featurePlugin: .sectionTitleDisplayable())
//        .add(featurePlugin: .sectionTitleDisplayable())
        .build()
    private var titles = ["Item 1", "Item 2", "Item 3", "Item 4"]

    private var appearance = UICollectionLayoutListConfiguration.Appearance.plain

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.setCollectionViewLayout(createCompositionalLayout(), animated: false) 
        fillAdapter()
    }
    
    
    func sectionOne() {
        addHeaderGenerator(with: "sectionOne")
        for _ in 0...30 {
            // Create viewModels for cell
            guard let viewModel = ImageCollectionViewCell.ViewModel.make() else { continue }

            // Create generator
            let generator = ImageCollectionViewCell.rddm.baseGenerator(with: viewModel)

            // Add generator to adapter
            adapter.addCellGenerator(generator)
        }
    }

}

// MARK: - Private Methods

@available(iOS 14.0, *)
private extension CollectionListViewController {

    func fillAdapter() {
        let header = HeaderCollectionListGenerator(title: "Section header")
        adapter.addSectionHeaderGenerator(header)

        for title in titles {
            let generator = TitleCollectionListCell.rddm.baseGenerator(with: title)
            generator.didSelectEvent += { debugPrint("\(title) selected") }
            adapter.addCellGenerator(generator)
        }
        sectionOne()
        adapter.forceRefill()
    }


}

//MARK: - Helper Method
@available(iOS 14.0, *)
private extension CollectionListViewController {

    func addHeaderGenerator(with title: String) {
        // Make header generator
        let headerGenerator = TitleCollectionHeaderGenerator(title: title)

        // Add header generator into adapter
        adapter.addSectionHeaderGenerator(headerGenerator)
    }

    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            switch sectionNumber {
            case 0: return self.firstLayoutSection()
            case 1: return self.secondLayoutSection()
            default: return self.thirdLayoutSection()
            }
        }
    }
    
    private func firstLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets.bottom = 15
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .fractionalWidth(0.5))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .init(top: 0, leading: 15, bottom: 0, trailing: 2)
       
        let section = NSCollectionLayoutSection(group: group)
        
        section.orthogonalScrollingBehavior = .groupPaging
        
        return section
    }
    
    private func secondLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33), heightDimension: .absolute(100))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 0, bottom: 15, trailing: 15)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(500))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
       
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets.leading = 15

        
        return section
    }
    
    private func thirdLayoutSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets.bottom = 15
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .fractionalWidth(0.35))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .init(top: 0, leading: 15, bottom: 0, trailing: 2)
       
        let section = NSCollectionLayoutSection(group: group)
        
        section.orthogonalScrollingBehavior = .continuous
        
        return section
    }
}


