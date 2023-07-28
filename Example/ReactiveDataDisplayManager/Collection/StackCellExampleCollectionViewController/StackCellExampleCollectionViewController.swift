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

    // MARK: - Private Properties

    private var cellBaseState = true
    private lazy var adapter = collectionView.rddm.baseBuilder
        .set(delegate: FlowCollectionDelegate())
        .add(plugin: .highlightable())
        .add(plugin: .selectable())
        .add(plugin: .accessibility())
        .build()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Stack incide collection"

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

        adapter += CollectionSection.create(header: EmptyCollectionHeaderGenerator(), footer: EmptyCollectionFooterGenerator()) { ctx in
            StackView.build(in: ctx, with: .build { hStack in
                hStack.style(.init(axis: .horizontal,
                                   spacing: 8,
                                   alignment: .fill,
                                   distribution: .fill))
                hStack.background(.solid(.gray))
                hStack.children { ctx in
                    SeparatorView.build(in: ctx, with: .init(size: .width(1), color: .black))
                    LabelView.build(in: ctx, with: .build { label in
                        label.text(.string("Some title"))
                        label.textAlignment(.left)
                        label.style(.init(color: .black, font: .preferredFont(forTextStyle: .headline)))
                    })
                    SpacerView.build(in: ctx, with: .init(size: .width(16)))
                    StackView.build(in: ctx, with: .build { vStack in
                        vStack.style(.init(axis: .vertical,
                                           spacing: 2,
                                           alignment: .center,
                                           distribution: .fill))
                        vStack.background(.solid(.rddm))
                        vStack.children { ctx in
                            LabelView.build(in: ctx, with: .build { label in
                                label.text(.string("Body 1"))
                                label.textAlignment(.right)
                                label.style(.init(color: .black, font: .preferredFont(forTextStyle: .body)))
                            })
                            LabelView.build(in: ctx, with: .build { label in
                                label.text(.string("Body 2"))
                                label.textAlignment(.right)
                                label.style(.init(color: .black, font: .preferredFont(forTextStyle: .body)))
                            })
                        }
                    })
                    SeparatorView.build(in: ctx, with: .init(size: .width(1), color: .black))
                }
            })
            TitleCollectionViewCell.build(in: ctx, with: "Some text outside of stack")
        }

        // Tell adapter that we've changed generators
        adapter => .reload
    }

}
