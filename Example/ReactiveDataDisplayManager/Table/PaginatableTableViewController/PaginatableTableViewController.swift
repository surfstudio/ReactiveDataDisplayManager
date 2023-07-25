//
//  PaginatableTableViewController.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Никита Коробейников on 03.03.2021.
//  Copyright © 2021 Alexander Kravchenkov. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager

final class PaginatableTableViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let pageSize = 16
        static let pagesCount = 3
    }

    // MARK: - IBOutlet

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - Private Properties

    private lazy var progressView = PaginatorView(frame: .init(x: 0, y: 0, width: tableView.frame.width, height: 80))

    private lazy var adapter = tableView.rddm.baseBuilder
        .add(plugin: .paginatable(progressView: progressView,
                                  output: self))
        .add(plugin: .accessibility())
        .build()

    private weak var paginatableInput: PaginatableInput?

    private var isFirstPageLoading = true
    private var currentPage = 0

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "pagination"

        configureActivityIndicatorIfNeeded()
        loadFirstPage()
    }

}

// MARK: - Configuration

private extension PaginatableTableViewController {

    func configureActivityIndicatorIfNeeded() {
        if #available(iOS 13.0, tvOS 13.0, *) {
            activityIndicator.style = .medium
        }
    }

}

// MARK: - Private Methods

private extension PaginatableTableViewController {

    func loadFirstPage() {

        // show loader
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()

        // hide footer
        paginatableInput?.updatePagination(canIterate: false)

        // imitation of loading first page
        delay(.now() + .seconds(3)) { [weak self] in

            // fill table
            self?.fillAdapter()

            // hide loader
            self?.activityIndicator?.stopAnimating()
            self?.activityIndicator?.isHidden = true

            // show footer
            self?.paginatableInput?.updatePagination(canIterate: true)
        }
    }

    /// This method is used to fill adapter
    func fillAdapter() {

        for _ in 0...Constants.pageSize {
            adapter += makeGenerator()
        }

        adapter => .reload
    }

    func makeGenerator() -> TableCellGenerator {
        TitleTableViewCell.rddm.baseGenerator(with: "Random cell \(Int.random(in: 0...1000)) from page \(currentPage)" )
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

        for _ in 0...Constants.pageSize {
            adapter += makeGenerator()
        }

        adapter => .reload

        return currentPage < Constants.pagesCount
    }

}

// MARK: - RefreshableOutput

extension PaginatableTableViewController: PaginatableOutput {

    func onPaginationInitialized(with input: PaginatableInput) {
        paginatableInput = input
    }

    func loadNextPage(with input: PaginatableInput) {

        input.updateProgress(isLoading: true)

        delay(.now() + .seconds(3)) { [weak self, weak input] in
            let canFillNext = self?.canFillNext() ?? false
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
