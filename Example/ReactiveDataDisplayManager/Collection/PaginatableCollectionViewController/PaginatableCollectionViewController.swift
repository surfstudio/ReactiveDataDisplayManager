//
//  PaginatableCollectionViewController.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Никита Коробейников on 16.03.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager

final class PaginatableCollectionViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let pageSize = 16
        static let pagesCount = 3
    }

    // MARK: - IBOutlet

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - Private Properties

    private lazy var progressView = PaginatorView(frame: .init(x: 0, y: 0, width: collectionView.frame.width, height: 80))

    private lazy var adapter = collectionView.rddm.baseBuilder
        .add(plugin: .bottomPaginatable(progressView: progressView, output: self))
        .build()

    private weak var paginatableInput: PaginatableInput?

    private var isFirstPageLoading = true
    private var currentPage = 0

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Collection with pagination"

        configureActivityIndicatorIfNeeded()
        loadFirstPage()
    }

}

// MARK: - Configuration

private extension PaginatableCollectionViewController {

    func configureActivityIndicatorIfNeeded() {
        if #available(iOS 13.0, tvOS 13.0, *) {
            activityIndicator.style = .medium
        }
    }

}

// MARK: - Private Methods

private extension PaginatableCollectionViewController {

    func loadFirstPage() {

        // show loader
        activityIndicator.isHidden = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()

        // hide footer
        paginatableInput?.updatePaginationEnabled(false, at: .forward(.bottom))
        paginatableInput?.updatePaginationState(.idle, at: .forward(.bottom))

        // imitation of loading first page
        delay(.now() + .seconds(3)) { [weak self] in
            // fill table
            self?.fillAdapter()

            // hide loader
            self?.activityIndicator?.stopAnimating()

            // show footer
            self?.paginatableInput?.updatePaginationEnabled(true, at: .forward(.bottom))
        }
    }

    /// This method is used to fill adapter
    func fillAdapter() {

        for _ in 0...Constants.pageSize {
            adapter += makeGenerator()
        }

        adapter => .reload
    }

    func makeGenerator() -> CollectionCellGenerator {
        let title = "Random cell \(Int.random(in: 0...1000)) from page \(currentPage)"
        return TitleCollectionViewCell.rddm.baseGenerator(with: title)
    }

    func canFillNext() -> Bool {
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

        return currentPage < Constants.pagesCount
    }

}

// MARK: - RefreshableOutput

extension PaginatableCollectionViewController: PaginatableOutput {

    func onPaginationInitialized(with input: PaginatableInput, at direction: PagingDirection) {
        paginatableInput = input
    }

    func loadNextPage(with input: PaginatableInput, at direction: PagingDirection) {

        input.updatePaginationState(.loading, at: direction)

        delay(.now() + .seconds(3)) { [weak self, weak input] in
            let canFillNext = self?.canFillNext() ?? false
            if canFillNext {
                let canIterate = self?.fillNext() ?? false

                input?.updatePaginationState(.idle, at: direction)
                input?.updatePaginationEnabled(canIterate, at: direction)
            } else {
                input?.updatePaginationState(.error(SampleError.sample), at: direction)
            }
        }
    }

}
