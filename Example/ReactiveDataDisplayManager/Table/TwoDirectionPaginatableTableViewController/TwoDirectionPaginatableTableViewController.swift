//
//  TwoDirectionPaginatableTableViewController.swift
//  ReactiveDataDisplayManager
//
//  Created by Антон Голубейков on 20.06.2023.
//

import UIKit
import ReactiveDataDisplayManager

final class TwoDirectionPaginatableTableViewController: UIViewController, PaginationDelegatable {

    // MARK: - Constants

    private enum Constants {
        static let pageSize = 40
        static let pagesCount = 10
        static let firstPageMiddleIndexPath = IndexPath(row: Constants.pageSize / 2, section: 0)
    }

    // MARK: - IBOutlet

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - Private Properties

    private lazy var forwardProgressView = PaginatorView(frame: .init(x: 0, y: 0, width: tableView.frame.width, height: 80))
    private lazy var backwardProgressView = PaginatorView(frame: .init(x: 0, y: 0, width: tableView.frame.width, height: 80))

    private lazy var adapter = tableView.rddm.manualBuilder
        .add(plugin: .paginatable(progressView: forwardProgressView,
                                  output: forwardPaginationDelegate,
                                  direction: .forward))
        .add(plugin: .paginatable(progressView: backwardProgressView,
                                  output: backwardPaginationDelegate,
                                  direction: .backward))
        .build()

    private weak var forwardPaginatableInput: PaginatableInput?
    private weak var backwardPaginatableInput: PaginatableInput?

    private lazy var forwardPaginationDelegate = ForwardPaginationDelegate(input: self, nextPageAction: loadNextPage)
    private lazy var backwardPaginationDelegate = BackwardPaginationDelegate(input: self, prevPageAction: loadPrevPage)

    private var isFirstPageLoading = true
    private var currentPage = 0

    private var sectionHeader: TableHeaderGenerator = EmptyTableHeaderGenerator()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Table with two directions pagination"

        configureActivityIndicatorIfNeeded()
        loadFirstPage()
    }

    // MARK: - PaginationDelegatable

    func initializeForwardPaginationInput(input: PaginatableInput) {
        forwardPaginatableInput = input
    }
    
    func initializeBackwardPaginationInput(input: PaginatableInput) {
        backwardPaginatableInput = input
    }

}

// MARK: - Configuration

private extension TwoDirectionPaginatableTableViewController {

    func configureActivityIndicatorIfNeeded() {
        if #available(iOS 13.0, tvOS 13.0, *) {
            activityIndicator.style = .medium
        }
    }

}

// MARK: - Private Methods

private extension TwoDirectionPaginatableTableViewController {

    func loadFirstPage() {

        // show loader
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()

        // hide footer and header
        forwardPaginatableInput?.updatePagination(canIterate: false)
        backwardPaginatableInput?.updatePagination(canIterate: false)

        // imitation of loading first page
        delay(.now() + .seconds(1)) { [weak self] in

            // fill table
            self?.fillAdapter()

            // scroll to middle
            self?.tableView.scrollToRow(at: Constants.firstPageMiddleIndexPath, at: .middle, animated: false)

            // hide loader
            self?.activityIndicator?.stopAnimating()
            self?.activityIndicator?.isHidden = true

            // show pagination loader if update is needed
            self?.forwardPaginatableInput?.updatePagination(canIterate: true)
            self?.backwardPaginatableInput?.updatePagination(canIterate: true)
        }
    }

    /// This method is used to fill adapter
    func fillAdapter() {
        adapter.addSectionHeaderGenerator(sectionHeader)

        for _ in 0...Constants.pageSize {
            adapter += makeGenerator()
        }

        adapter => .reload
    }

    func makeGenerator() -> TableCellGenerator {
        TitleTableViewCell.rddm.baseGenerator(with: "Random cell \(Int.random(in: 0...1000)) from page \(currentPage)" )
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
        var generators = [TableCellGenerator]()

        for _ in 0...Constants.pageSize {
            let generator = makeGenerator()
            generators.append(generator)
        }
        adapter.insertAtEnd(to: sectionHeader, new: generators, with: .none)

        return currentPage < Constants.pagesCount
    }

    func fillPrev() -> Bool {
        currentPage += 1
        var generators = [TableCellGenerator]()

        for _ in 0...Constants.pageSize {
            let generator = makeGenerator()
            generators.append(generator)
        }
        adapter.insertAtBeginning(to: sectionHeader, new: generators, with: .none)

        return currentPage < Constants.pagesCount
    }

    func loadNextPage() {
        forwardPaginatableInput?.updateProgress(isLoading: true)

        delay(.now() + .seconds(2)) { [weak self] in
            let canFillPages = self?.canFillPages() ?? false

            if canFillPages {
                let canIterate = self?.fillNext() ?? false

                self?.forwardPaginatableInput?.updateProgress(isLoading: false)
                self?.forwardPaginatableInput?.updatePagination(canIterate: canIterate)
            } else {
                self?.forwardPaginatableInput?.updateProgress(isLoading: false)
                self?.forwardPaginatableInput?.updateError(SampleError.sample)
            }
        }
    }

    func loadPrevPage() {
        backwardPaginatableInput?.updateProgress(isLoading: true)

        delay(.now() + .seconds(2)) { [weak self] in
            guard let self = self else {
                return
            }

            if self.canFillPages() {
                let currentFirstGenerator = self.adapter.sections.first?.generators.first
                let canIterate = self.fillPrev()

                if let currentFirstGenerator = currentFirstGenerator {
                    self.adapter.scrollTo(generator: currentFirstGenerator, scrollPosition: .top, animated: false)
                }
                self.backwardPaginatableInput?.updateProgress(isLoading: false)
                self.backwardPaginatableInput?.updatePagination(canIterate: canIterate)
            } else {
                self.backwardPaginatableInput?.updateProgress(isLoading: false)
                self.backwardPaginatableInput?.updateError(SampleError.sample)
            }
        }
    }

}