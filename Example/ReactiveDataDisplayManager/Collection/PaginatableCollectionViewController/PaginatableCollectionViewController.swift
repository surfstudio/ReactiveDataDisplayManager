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
        .add(plugin: .paginatable(progressView: progressView,
                                  output: self))
        .build()

    private weak var paginatableInput: PaginatableInput?

    private var currentPage = 0

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Collection with pagination"
        loadFirstPage()
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
        paginatableInput?.updatePagination(canIterate: false)
        paginatableInput?.updateProgress(isLoading: false)

        // imitation of loading first page
        delay(.now() + .seconds(3)) { [weak self] in
            
            // fill table
            self?.fillAdapter()

            // hide loader
            self?.activityIndicator?.stopAnimating()

            // show footer
            self?.paginatableInput?.updatePagination(canIterate: true)

        }
    }

    /// This method is used to fill adapter
    func fillAdapter() {

        for _ in 0...Constants.pageSize {
            adapter.addCellGenerator(makeGenerator())
        }

        adapter.forceRefill()
    }

    func delay(_ deadline: DispatchTime, completion: @escaping () -> Void) {
        DispatchQueue.global().asyncAfter(deadline: deadline) {
            DispatchQueue.main.async {
                completion()
            }
        }
    }

    func makeGenerator() -> CollectionCellGenerator {
        TitleCollectionViewCell.rddm.baseGenerator(with: "Random cell \(Int.random(in: 0...1000)) from page \(currentPage)" )
    }

    func fillNext() -> Bool {
        currentPage += 1

        for _ in 0...Constants.pageSize {
            adapter.addCellGenerator(makeGenerator())
        }

        adapter.forceRefill()

        return currentPage < Constants.pagesCount
    }

}


// MARK: - RefreshableOutput

extension PaginatableCollectionViewController: PaginatableOutput {

    func onPaginationInitialized(with input: PaginatableInput) {
        paginatableInput = input
    }

    func loadNextPage(with input: PaginatableInput) {

        input.updateProgress(isLoading: true)

        delay(.now() + .seconds(3)) { [weak self, weak input] in
            let canIterate = self?.fillNext() ?? false

            input?.updateProgress(isLoading: false)
            input?.updatePagination(canIterate: canIterate)
        }
    }

}
