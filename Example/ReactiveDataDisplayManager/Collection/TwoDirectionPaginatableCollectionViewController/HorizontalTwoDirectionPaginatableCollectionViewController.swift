//
//  HorizontalTwoDirectionPaginatableCollectionViewController.swift
//  ReactiveDataDisplayManagerExample_iOS
//
//  Created by Konstantin Porokhov on 30.08.2023.
//

import UIKit
import ReactiveDataDisplayManager
import ReactiveDataComponents

final class HorizontalTwoDirectionPaginatableCollectionViewController: UIViewController {

    // MARK: - Nested types

    private enum ScrollDirection {
        case left
        case right
    }

    // MARK: - Constants

    private enum Constants {
        static let maxPagesCount = 5
        static let pageSize = 20
        static let paginatorHeight: CGFloat = 80
        static let firstPageMiddleIndexPath = IndexPath(row: Constants.pageSize / 2, section: 0)
    }

    // MARK: - IBOutlet

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - Private Properties

    private lazy var leftProgressView = PaginatorView(frame: .init(x: 0,
                                                                   y: 0,
                                                                   width: 200,
                                                                   height: collectionView.frame.height))
    private lazy var rightProgressView = PaginatorView(frame: .init(x: 0,
                                                                    y: 0,
                                                                    width: 200,
                                                                    height: collectionView.frame.height))

    private lazy var adapter = collectionView.rddm.baseBuilder
        .add(plugin: .leftPaginatable(progressView: leftProgressView, output: self))
        .add(plugin: .rightPaginatable(progressView: rightProgressView, output: self))
        .build()

    private weak var bottomPaginatableInput: PaginatableInput?
    private weak var topPaginatableInput: PaginatableInput?

    private var isFirstPageLoading = true
    private var currentLeftPage = 0
    private var currentRightPage = 0

    private lazy var emptyCell = CollectionSpacerCell.rddm.baseGenerator(with: CollectionSpacerCell.Model(height: 0), and: .class)

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Collection with two direction pagination"

        configureActivityIndicatorIfNeeded()
        configureCollectionView()
        loadFirstPage()
    }

}

// MARK: - Configuration

private extension HorizontalTwoDirectionPaginatableCollectionViewController {

    func configureActivityIndicatorIfNeeded() {
        if #available(iOS 13.0, tvOS 13.0, *) {
            activityIndicator.style = .medium
        }
    }

}

// MARK: - Private Methods

private extension HorizontalTwoDirectionPaginatableCollectionViewController {

    func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = .init(width: 300, height: 200)
        collectionView.setCollectionViewLayout(layout, animated: true)
    }

    func loadFirstPage() {

        // show loader
        activityIndicator.isHidden = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()

        // hide footer
        bottomPaginatableInput?.updatePaginationEnabled(false, at: .forward(.bottom))
        topPaginatableInput?.updatePaginationEnabled(false, at: .backward(.top))
        bottomPaginatableInput?.updatePaginationState(.idle, at: .forward(.bottom))
        topPaginatableInput?.updatePaginationState(.loading, at: .backward(.top))

        // imitation of loading first page
        delay(.now() + .seconds(3)) { [weak self] in
            // fill table
            self?.fillAdapter()

            // hide loader
            self?.activityIndicator?.stopAnimating()

            // scroll to middle
            self?.collectionView.scrollToItem(at: Constants.firstPageMiddleIndexPath, at: .centeredVertically, animated: false)

            // show pagination loader if update is needed
            self?.bottomPaginatableInput?.updatePaginationEnabled(true, at: .forward(.bottom))
            self?.topPaginatableInput?.updatePaginationEnabled(true, at: .backward(.top))
        }
    }

    /// This method is used to fill adapter
    func fillAdapter() {
        adapter += emptyCell

        for _ in 0...Constants.pageSize {
            adapter += makeGenerator()
        }

        adapter => .reload
    }

    private func makeGenerator(for scrollDirection: ScrollDirection? = nil) -> CollectionCellGenerator {
        var currentPage = 0
        if let scrollDirection = scrollDirection {
            switch scrollDirection {
            case .left:
                currentPage = currentLeftPage
            case .right:
                currentPage = currentRightPage
            }
        }

        let title = "Random cell \(Int.random(in: 0...1000)) from page \(currentPage)"
        return TitleCollectionViewCell.rddm.baseGenerator(with: title)
    }

    func canFillPages() -> Bool {
        if isFirstPageLoading {
            isFirstPageLoading.toggle()
            return false
        } else {
            return true
        }
    }

    func fillNext() -> Bool {
        currentRightPage += 1

        var newGenerators = [CollectionCellGenerator]()

        for _ in 0...Constants.pageSize {
            newGenerators.append(makeGenerator(for: .right))
        }

        if let lastGenerator = adapter.sections.last?.generators.last {
            adapter.insert(after: lastGenerator, new: newGenerators)
        } else {
            adapter += newGenerators
            adapter => .reload
        }

        return currentRightPage != Constants.maxPagesCount
    }

    func fillPrev() -> Bool {
        currentLeftPage -= 1

        let newGenerators = (0...Constants.pageSize).map { _ in
            return makeGenerator(for: .left)
        }
        adapter.insert(after: emptyCell, new: newGenerators, with: nil)

        return abs(currentLeftPage) != Constants.maxPagesCount
    }

}

// MARK: - PaginatableOutput

extension HorizontalTwoDirectionPaginatableCollectionViewController: PaginatableOutput {

    func onPaginationInitialized(with input: PaginatableInput, at direction: PagingDirection) {
        switch direction {
        case .backward:
            topPaginatableInput = input
        case .forward:
            bottomPaginatableInput = input
        }
    }

    func loadNextPage(with input: PaginatableInput, at direction: PagingDirection) {

        input.updatePaginationState(.loading, at: direction)

        delay(.now() + .seconds(3)) { [weak self, weak input] in
            let canFillNext = self?.canFillPages() ?? false
            if canFillNext {
                let canIterate: Bool
                switch direction {
                case .backward:
                    canIterate = self?.fillPrev() ?? false
                case .forward:
                    canIterate = self?.fillNext() ?? false
                }

                input?.updatePaginationState(.idle, at: direction)
                input?.updatePaginationEnabled(canIterate, at: direction)
            } else {
                input?.updatePaginationState(.error(SampleError.sample), at: direction)
            }
        }
    }

}
