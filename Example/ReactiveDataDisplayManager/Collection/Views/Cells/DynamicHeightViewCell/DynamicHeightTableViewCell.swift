//
//  DynamicHeightTableViewCell.swift
//  ReactiveDataDisplayManagerExample_iOS
//
//  Created by porohov on 15.11.2021.
//

import UIKit
import ReactiveDataDisplayManager

final class DynamicHeightTableViewCell: UITableViewCell, ConfigurableItem, ConstractableItem {

    static var constructionType: ConstructionType {
        .xib
    }

    // MARK: - Constants

    private enum Constants {
        static let cellSize = CGSize(width: 120, height: 120)
        static let sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
        static let horizontalItemSpace: CGFloat = 20
    }

    // MARK: - @IBOutlet

    @IBOutlet private weak var collectionView: DynamicHeightCollectionView!

    // MARK: - Private Properties

    private lazy var adapter = collectionView.rddm.baseBuilder.build()

    // MARK: - UITableViewCell

    override func awakeFromNib() {
        super.awakeFromNib()
        fillAdapter()
        configureLayoutFlow()
    }

    // MARK: - ConfigurableItem

    func configure(with model: ()) { }

}

// MARK: - Private Methods

private extension DynamicHeightTableViewCell {

    func fillAdapter() {
        adapter += makeDynamicHeightCellGenerators()
        adapter.forceRefill()

        // needed to update the height
        layoutIfNeeded()
    }

    func makeDynamicHeightCellGenerators() -> [CollectionCellGenerator] {
        return makeModels().map { BaseCollectionCellGenerator<RectangleColorCollectionViewCell>(with: $0) }
    }

    func makeModels() -> [UIColor] {
        let count = Int.random(in: 3...8)
        return Array(0...count).map { _ in UIColor.random }
    }

    func configureLayoutFlow() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = Constants.cellSize
        layout.sectionInset = Constants.sectionInset
        layout.minimumLineSpacing = Constants.horizontalItemSpace
        layout.minimumInteritemSpacing = .zero
        collectionView.setCollectionViewLayout(layout, animated: false)
    }

}

// MARK: - Support

extension UIColor {

    static var random: UIColor {
        return UIColor(red: .random(in: 0...2), green: .random(in: 0...2), blue: .random(in: 0...2), alpha: 1.0)
    }

}
