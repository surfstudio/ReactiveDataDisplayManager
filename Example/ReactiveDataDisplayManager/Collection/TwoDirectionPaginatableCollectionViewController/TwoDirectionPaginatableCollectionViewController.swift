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

    // MARK: - Constants

    private enum Constants {
        static let pageSize = 20
        static let paginatorHeight: CGFloat = 80
        static let firstPageMiddleIndexPath = IndexPath(row: Constants.pageSize / 2, section: 0)
    }

    // MARK: - IBOutlet

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - Private Properties

    private lazy var forwardProgressView = PaginatorView(frame: .init(x: 0,
                                                                      y: 0,
                                                                      width: collectionView.frame.width,
                                                                      height: Constants.paginatorHeight))
    private lazy var backwardProgressView = PaginatorView(frame: .init(x: 0,
                                                                       y: 0,
                                                                       width: collectionView.frame.width,
                                                                       height: Constants.paginatorHeight))

    private lazy var adapter = collectionView.rddm.baseBuilder
        .add(plugin: .paginatable(progressView: forwardProgressView, output: self))
        .add(plugin: .backwardPaginatable(progressView: backwardProgressView, output: self))
        .build()

    private weak var forwardPaginatableInput: PaginatableInput?
    private weak var backwardPaginatableInput: BackwardPaginatableInput?

    private var isFirstPageLoading = true
    private var currentPage = 0

    private lazy var emptyCell = CollectionSpacerCell.rddm.baseGenerator(with: CollectionSpacerCell.Model(height: 0), and: .class)

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Collection with two direction pagination"

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
        forwardPaginatableInput?.updatePagination(canIterate: false)
        backwardPaginatableInput?.updatePagination(canIterate: false)
        forwardPaginatableInput?.updateProgress(isLoading: false)
        backwardPaginatableInput?.updateProgress(isLoading: false)

        // imitation of loading first page
        delay(.now() + .seconds(3)) { [weak self] in
            // fill table
            self?.fillAdapter()

            // hide loader
            self?.activityIndicator?.stopAnimating()

            // scroll to middle
            self?.collectionView.scrollToItem(at: Constants.firstPageMiddleIndexPath, at: .centeredVertically, animated: false)

            // show pagination loader if update is needed
            self?.forwardPaginatableInput?.updatePagination(canIterate: true)
            self?.backwardPaginatableInput?.updatePagination(canIterate: true)
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

    func makeGenerator() -> CollectionCellGenerator {
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
        currentPage += 1

        var newGenerators = [CollectionCellGenerator]()

        for _ in 0...Constants.pageSize {
            newGenerators.append(makeGenerator())
        }

        if let lastGenerator = adapter.sections.last?.generators.last {
            adapter.insert(after: lastGenerator, new: newGenerators)
        } else {
            adapter += newGenerators
            adapter => .reload
        }

        // pages count is infinite if it`s a single direction scroll
        return currentPage != 0
    }

    func fillPrev() -> Bool {
        currentPage -= 1

        let newGenerators = (0...Constants.pageSize).map { _ in
            return makeGenerator()
        }
        adapter.insert(after: emptyCell, new: newGenerators, with: nil)

        // pages count is infinite if it`s a single direction scroll
        return currentPage != 0
    }

}

// MARK: - PaginatableOutput

extension TwoDirectionPaginatableCollectionViewController: PaginatableOutput {

    func onPaginationInitialized(with input: PaginatableInput) {
        forwardPaginatableInput = input
    }

    func loadNextPage(with input: PaginatableInput) {

        input.updateProgress(isLoading: true)

        delay(.now() + .seconds(3)) { [weak self, weak input] in
            let canFillNext = self?.canFillPages() ?? false
            if canFillNext {
                let canIterate = self?.fillNext() ?? false

                input?.updateProgress(isLoading: false)
                input?.updatePagination(canIterate: canIterate)
                self?.backwardPaginatableInput?.updatePagination(canIterate: canIterate)
            } else {
                input?.updateProgress(isLoading: false)
                input?.updateError(SampleError.sample)
            }
        }
    }

}

// MARK: - BackwardPaginatableOutput

extension TwoDirectionPaginatableCollectionViewController: BackwardPaginatableOutput {

    func onBackwardPaginationInitialized(with input: ReactiveDataDisplayManager.BackwardPaginatableInput) {
        backwardPaginatableInput = input
    }

    func loadPrevPage(with input: ReactiveDataDisplayManager.BackwardPaginatableInput) {
        input.updateProgress(isLoading: true)

        delay(.now() + .seconds(2)) { [weak self, weak input] in
            guard let self = self else {
                return
            }
            if self.canFillPages() {
                let canIterate = self.fillPrev()
                input?.updateProgress(isLoading: false)
                input?.updatePagination(canIterate: canIterate)
                input?.returnToScrollPositionBeforeLoading()
                self.forwardPaginatableInput?.updatePagination(canIterate: canIterate)
            } else {
                input?.updateProgress(isLoading: false)
                input?.updateError(SampleError.sample)
            }
        }
    }

}
