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
    private lazy var titleCell = TitleTableViewCell.buildView(with: "Title")

    // MARK: - Private Properties

    private var cellBaseState = true
    private lazy var adapter = collectionView.rddm.baseBuilder
        .set(delegate: FlowCollectionDelegate())
        .add(plugin: .highlightable())
        .add(plugin: .selectable())
        .build()

    lazy var horizontalNestedStackCell = HorizontalCollectionStack {
        TitleTableViewCell.buildView(with: "Text 3")
        TitleTableViewCell.buildView(with: "Text 4")
    }

    lazy var verticalStackCell = VerticalCollectionStack(space: 8) {
        titleCell
            .set(font: UIFont.boldSystemFont(ofSize: 20))
        TitleTableViewCell.buildView(with: "Text 1")
        TitleTableViewCell.buildView(with: "Text 2")
        horizontalNestedStackCell
        SeparatorView.buildView(with: .init(size: .height(1), color: .lightGray), and: .class)
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
            .didSelectEvent { [weak self] in
                self?.cellBaseState.toggle()
                self?.titleCell.configure(with: (self?.cellBaseState ?? true) ? "Title" : "Very very very long title")
                self?.verticalStackCell.updateSizeIfNeaded()
            }

        adapter += VerticalCollectionStack {
            SeparatorView.buildView(with: .init(size: .height(1), color: .black), and: .class)

            HorizontalCollectionStack {
                SeparatorView.buildView(with: .init(size: .width(1), color: .black), and: .class)
                SpacerView.buildView(with: .init(size: .width(64)), and: .class)

                TitleTableViewCell.buildView(with: "Some text")

                SeparatorView.buildView(with: .init(size: .width(1), color: .black), and: .class)
            }

            SeparatorView.buildView(with: .init(size: .height(1), color: .black), and: .class)
        }

        // Tell adapter that we've changed generators
        adapter => .reload
    }

}
