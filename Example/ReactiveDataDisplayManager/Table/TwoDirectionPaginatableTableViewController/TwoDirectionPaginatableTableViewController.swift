//
//  TwoDirectionPaginatableTableViewController.swift
//  ReactiveDataDisplayManager
//
//  Created by Антон Голубейков on 20.06.2023.
//

import UIKit
import ReactiveDataDisplayManager

final class TwoDirectionPaginatableTableViewController: UIViewController {

    // MARK: - Nested types

    private enum ScrollDirection {
        case top
        case bottom
    }

    // MARK: - Constants

    private enum Constants {
        static let maxPagesCount = 5
        static let pageSize = 40
        static let firstPageMiddleIndexPath = IndexPath(row: Constants.pageSize / 2, section: 0)
        static let paginatorViewHeight: CGFloat = 80
    }

    // MARK: - IBOutlet

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - Private Properties

    private lazy var bottomProgressView = PaginatorView(frame: .init(x: 0,
                                                                     y: 0,
                                                                     width: tableView.frame.width,
                                                                     height: Constants.paginatorViewHeight))
    private lazy var topProgressView = PaginatorView(frame: .init(x: 0,
                                                                  y: 0,
                                                                  width: tableView.frame.width,
                                                                  height: Constants.paginatorViewHeight))

    private lazy var adapter = tableView.rddm.manualBuilder
        .add(plugin: .paginatable(progressView: bottomProgressView,
                                  output: self))
        .add(plugin: .topPaginatable(progressView: topProgressView,
                                     output: self,
                                     isSaveScrollPositionNeeded: true))
        .build()

    private weak var bottomPaginatableInput: PaginatableInput?
    private weak var topPaginatableInput: TopPaginatableInput?

    private var isFirstPageLoading = true
    private var currentTopPage = 0
    private var currentBottomPage = 0

    private var sectionHeader: TableHeaderGenerator = EmptyTableHeaderGenerator()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Table with two directions pagination"

        configureActivityIndicatorIfNeeded()
        loadFirstPage()
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
        bottomPaginatableInput?.updatePagination(canIterate: false)
        topPaginatableInput?.updatePagination(canIterate: false)

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
            self?.bottomPaginatableInput?.updatePagination(canIterate: true)
            self?.topPaginatableInput?.updatePagination(canIterate: true)
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

    private func makeGenerator(for scrollDirection: ScrollDirection? = nil) -> TableCellGenerator {
        var currentPage = 0
        if let scrollDirection = scrollDirection {
            switch scrollDirection {
            case .top:
                currentPage = currentTopPage
            case .bottom:
                currentPage = currentBottomPage
            }
        }

        return TitleTableViewCell.rddm.calculatableHeightGenerator(with: "Random cell \(Int.random(in: 0...1000)) from page \(currentPage)" )
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

        let generators = (0...Constants.pageSize).map { _ in
            return makeGenerator(for: .bottom)
        }

        adapter.insertAtEnd(to: sectionHeader, new: generators, with: .animated(.bottom))

        return currentBottomPage != Constants.maxPagesCount
    }

    func fillPrev() -> Bool {
        currentTopPage -= 1

        let generators = (0...Constants.pageSize).map { _ in
            return makeGenerator(for: .top)
        }

        adapter.insertAtBeginning(to: sectionHeader, new: generators, with: .notAnimated)

        return abs(currentTopPage) != Constants.maxPagesCount
    }

}

// MARK: - PaginatableOutput

extension TwoDirectionPaginatableTableViewController: PaginatableOutput {

    func onPaginationInitialized(with input: PaginatableInput) {
        bottomPaginatableInput = input
    }

    func loadNextPage(with input: PaginatableInput) {
        input.updateProgress(isLoading: true)

        delay(.now() + .seconds(2)) { [weak self, weak input] in
            let canFillPages = self?.canFillPages() ?? false

            if canFillPages {
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

extension TwoDirectionPaginatableTableViewController: TopPaginatableOutput {

    func onTopPaginationInitialized(with input: TopPaginatableInput) {
        topPaginatableInput = input
    }

    func loadPrevPage(with input: TopPaginatableInput) {
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
