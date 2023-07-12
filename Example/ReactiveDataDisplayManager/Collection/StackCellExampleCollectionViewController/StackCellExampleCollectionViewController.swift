//
//  StackCellExampleCollectionViewController.swift
//  ReactiveDataDisplayManagerExample_iOS
//
//  Created by Konstantin Porokhov on 30.06.2023.
//

import UIKit
import ReactiveDataComponents
import ReactiveDataDisplayManager

final class StackCellExampleCollectionViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        static let sampleText = "LongText".localized
        static let cellVerticalCount = Array(1...10)
        static let cellHorizontalCount = Array(1...2)
    }

    // MARK: - IBOutlet

    @IBOutlet private weak var collectionView: UICollectionView!
    private lazy var cell1 = TitleTableViewCell.build(with: "Cell 1")

    // MARK: - Private Properties

    private lazy var adapter = collectionView.rddm.baseBuilder
        .set(delegate: FlowCollectionDelegate())
        .add(plugin: .highlightable())
        .add(plugin: .selectable())
        .build()

    lazy var horizontalNestedStackCell = HorizontalCollectionStack {
        TitleTableViewCell.build(with: "Текст 1")
        TitleTableViewCell.build(with: "Текст 2")
    }

    lazy var verticalStackCell = VerticalCollectionStack(space: 8) {
        cell1
        TitleTableViewCell.build(with: "Текст 1")
        TitleTableViewCell.build(with: "Текст 2")
        horizontalNestedStackCell
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Stack cell collection"

        let flowLayout = makeFlowLayout()
        collectionView.setCollectionViewLayout(flowLayout, animated: false)

        fillAdapter()
    }

}

// MARK: - Private Methods

private extension StackCellExampleCollectionViewController {
    
    func makeFlowLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 10.0
        flowLayout.sectionInset = Constants.sectionInset
        flowLayout.scrollDirection = .vertical
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        return flowLayout
    }
    
    /// This method is used to fill adapter
    func fillAdapter() {
    
        // Add stack generators into adapter
        adapter += verticalStackCell
    
        // Tell adapter that we've changed generators
        adapter => .reload
    
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.cell1.configure(with: "12345")
        }
    }

}
