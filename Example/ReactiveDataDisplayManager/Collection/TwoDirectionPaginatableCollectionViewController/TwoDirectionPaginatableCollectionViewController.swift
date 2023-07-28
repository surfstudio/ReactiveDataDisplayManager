//
//  TwoDirectionPaginatableCollectionViewController.swift
//  ReactiveDataDisplayManager
//
//  Created by Антон Голубейков on 23.06.2023.
//

import UIKit
import ReactiveDataDisplayManager
import ReactiveDataComponents

final class TwoDirectionPaginatableCollectionViewController: UIViewController {

    // MARK: - Nested types

    private enum ScrollDirection {
        case top
        case bottom
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

    private lazy var bottomProgressView = PaginatorView(frame: .init(x: 0,
                                                                      y: 0,
                                                                      width: collectionView.frame.width,
                                                                      height: Constants.paginatorHeight))
    private lazy var topProgressView = PaginatorView(frame: .init(x: 0,
                                                                       y: 0,
                                                                       width: collectionView.frame.width,
                                                                       height: Constants.paginatorHeight))

    private lazy var adapter = collectionView.rddm.baseBuilder
        .add(plugin: .paginatable(progressView: bottomProgressView, output: self))
        .add(plugin: .topPaginatable(progressView: topProgressView,
                                     output: self,
                                     isSaveScrollPositionNeeded: true))
        .build()

    private weak var bottomPaginatableInput: PaginatableInput?
    private weak var topPaginatableInput: TopPaginatableInput?

    private var isFirstPageLoading = true
    private var currentTopPage = 0
    private var currentBottomPage = 0

    private lazy var emptyCell = SpacerView.rddm.collectionGenerator(with: .init(size: .height(0)))

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "two directional pagination"

        configureActivityIndicatorIfNeeded()
        loadFirstPage()
    }

}

// MARK: - Configuration

private extension TwoDirectionPaginatableCollectionViewController {

    func configureActivityIndicatorIfNeeded() {
        if #available(iOS 13.0, tvOS 13.0, *) {
            activityIndicator.style = .medium
        }
    }

}

// MARK: - Private Methods

private extension TwoDirectionPaginatableCollectionViewController {

    func loadFirstPage() {

        // show loader
        activityIndicator.isHidden = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()

        // hide footer
        bottomPaginatableInput?.updatePagination(canIterate: false)
        topPaginatableInput?.updatePagination(canIterate: false)
        bottomPaginatableInput?.updateProgress(isLoading: false)
        topPaginatableInput?.updateProgress(isLoading: false)

        // imitation of loading first page
        delay(.now() + .seconds(3)) { [weak self] in
            // fill table
            self?.fillAdapter()

            // hide loader
            self?.activityIndicator?.stopAnimating()

            // scroll to middle
            self?.collectionView.scrollToItem(at: Constants.firstPageMiddleIndexPath, at: .centeredVertically, animated: false)

            // show pagination loader if update is needed
            self?.bottomPaginatableInput?.updatePagination(canIterate: true)
            self?.topPaginatableInput?.updatePagination(canIterate: true)
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
            case .top:
                currentPage = currentTopPage
            case .bottom:
                currentPage = currentBottomPage
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
        currentBottomPage += 1

        var newGenerators = [CollectionCellGenerator]()

        for _ in 0...Constants.pageSize {
            newGenerators.append(makeGenerator(for: .bottom))
        }

        if let lastGenerator = adapter.sections.last?.generators.last {
            adapter.insert(after: lastGenerator, new: newGenerators)
        } else {
            adapter += newGenerators
            adapter => .reload
        }

        return currentBottomPage != Constants.maxPagesCount
    }

    func fillPrev() -> Bool {
        currentTopPage -= 1

        let newGenerators = (0...Constants.pageSize).map { _ in
            return makeGenerator(for: .top)
        }
        adapter.insert(after: emptyCell, new: newGenerators, with: nil)

        return abs(currentTopPage) != Constants.maxPagesCount
    }

}

// MARK: - PaginatableOutput

extension TwoDirectionPaginatableCollectionViewController: PaginatableOutput {

    func onPaginationInitialized(with input: PaginatableInput) {
        bottomPaginatableInput = input
    }

    func loadNextPage(with input: PaginatableInput) {

        input.updateProgress(isLoading: true)

        delay(.now() + .seconds(3)) { [weak self, weak input] in
            let canFillNext = self?.canFillPages() ?? false
            if canFillNext {
                let canIterate = self?.fillNext() ?? false

                input?.updateProgress(isLoading: false)
                input?.updatePagination(canIterate: canIterate)
            } else {
                input?.updateProgress(isLoading: false)
                input?.updateError(SampleError.sample)
            }
        }
    }

}

// MARK: - TopPaginatableOutput

extension TwoDirectionPaginatableCollectionViewController: TopPaginatableOutput {

    func onTopPaginationInitialized(with input: ReactiveDataDisplayManager.TopPaginatableInput) {
        topPaginatableInput = input
    }

    func loadPrevPage(with input: ReactiveDataDisplayManager.TopPaginatableInput) {
        input.updateProgress(isLoading: true)

        delay(.now() + .seconds(2)) { [weak self, weak input] in
            guard let self = self else {
                return
            }
            if self.canFillPages() {
                let canIterate = self.fillPrev()
                input?.updateProgress(isLoading: false)
                input?.updatePagination(canIterate: canIterate)
            } else {
                input?.updateProgress(isLoading: false)
                input?.updateError(SampleError.sample)
            }
        }
    }

}
